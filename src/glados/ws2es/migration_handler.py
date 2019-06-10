import argparse
import sys
import glados.ws2es.es_util as es_util
from glados.ws2es.resource_iterator import ResourceIterator, SharedThreadPool
import glados.ws2es.resources_description as resources_description
import glados.ws2es.progress_bar_handler
import glados.ws2es.migration_common as migration_common

__author__ = 'jfmosquera@ebi.ac.uk'


# ----------------------------------------------------------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------------------------------------------------------


def query_yes_no(question, default="yes"):
    """
    Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")


def main():
    parser = argparse.ArgumentParser(description="Migrate ChEMBL data from the WebServices to Elastic Search")
    parser.add_argument("-A", "--all",
                        dest="migrate_all",
                        help="Migrate all the data in the WebServices, "
                             "if missing defaults to only 1000 records per resource.",
                        action="store_true",)
    parser.add_argument("--ignore-warning",
                        dest="ignore_warning",
                        help="Ignores the initial warning about index deletion.",
                        action="store_true",)
    parser.add_argument("-GM", "--generate_mappings",
                        dest="generate_mappings",
                        help="Generate elastic search mapping skeleton files without migrating",
                        action="store_true",)
    parser.add_argument("--host",
                        dest="es_host",
                        help="Elastic Search Hostname or IP address.",
                        default="localhost")
    parser.add_argument("--port",
                        dest="es_port",
                        help="Elastic Search port.",
                        default=9200)
    parser.add_argument("--resource",
                        dest="ws_resource",
                        help="Web Services resource to iterate, if not specified will iterate all the resources.",
                        default=None)
    parser.add_argument("--production",
                        dest="ws_prod_env",
                        help="If included will use the production environment of the WS, if not will default to dev.",
                        action="store_true",)
    parser.add_argument("-CA", "--create-alias",
                        dest="create_alias",
                        help="If included will create alias for the configured resources.",
                        action="store_true",)
    parser.add_argument("-UAC",
                        dest="update_autocomplete_only",
                        help="If included will only update the auto complete fields.",
                        action="store_true",)
    args = parser.parse_args()

    if args.create_alias:
        resources_description.ResourceDescription.create_all_aliases(args.es_host, args.es_port)
        sys.exit(0)

    es_util.setup_connection(args.es_host, args.es_port)

    migration_common.UPDATE_AUTOCOMPLETE_ONLY = args.update_autocomplete_only

    if not es_util.ping():
        print("ERROR: Can't ping the elastic search server.", file=sys.stderr)
        sys.exit(1)

    selected_resources = None
    if args.ws_resource:
        selected_resources = args.ws_resource.split(',')

    if args.generate_mappings:
        migration_common.generate_mappings_for_resources(selected_resources)
        return

    if not args.ignore_warning:
        if not query_yes_no("This procedure will delete and create all indexes again in the server.\n"
                            "Do you want to proceed?", default="no"):
            return

    on_start = migration_common.create_res_idx
    on_doc = migration_common.write_res_doc2es_first_id
    on_done = None
    iterate_all = args.migrate_all

    iterator_thread_pool = SharedThreadPool(max_workers=10)

    prod_env = False
    if args.ws_prod_env:
        prod_env = True
    resources_description.set_ws_env(prod_env)

    if args.ws_resource:
        resource = resources_description.RESOURCES_BY_RES_NAME.get(args.ws_resource, None)
        if resource is None:
            print('Unknown resource {0}'.format(args.ws_resource), file=sys.stderr)
        iterator = ResourceIterator(
            resource, iterator_thread_pool,
            on_start=on_start, on_doc=on_doc, on_done=on_done, iterate_all=iterate_all, redo_failed_chunks=True
        )
        iterator.start()
        iterator.join()
    else:
        iterators = []
        for resource_i in resources_description.ALL_WS_RESOURCES:
            res_it_i = ResourceIterator(
                resource_i, iterator_thread_pool,
                on_start=on_start, on_doc=on_doc, on_done=on_done, iterate_all=iterate_all, redo_failed_chunks=True
            )
            res_it_i.start()
            iterators.append(res_it_i)
        for res_it_i in iterators:
            res_it_i.join()

    es_util.bulk_submitter.join()
    for res_i in resources_description.ALL_WS_RESOURCES_NAMES:
        if migration_common.MIG_TOTAL[res_i] > 0:
            migration_common.MIG_LOG.info("{0} migrated {1} out of {2} tried out of {3} total".format(
                res_i,
                migration_common.MIG_SUCCESS_COUNT[res_i],
                migration_common.MIG_TRIED_COUNT[res_i],
                migration_common.MIG_TOTAL[res_i])
            )
    glados.ws2es.progress_bar_handler.write_after_progress_bars()


if __name__ == "__main__":
    main()
