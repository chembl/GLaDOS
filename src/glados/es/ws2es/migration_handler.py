import argparse
import sys
import time
from datetime import datetime, timedelta
from glados.es.ws2es.es_util import es_util
from glados.es.ws2es.resource_iterator import ResourceIterator, SharedThreadPool
from glados.es.ws2es.util import query_yes_no
import glados.es.ws2es.resources_description as resources_description
import glados.es.ws2es.progress_bar_handler
import glados.es.ws2es.migration_common as migration_common

__author__ = 'jfmosquera@ebi.ac.uk'


# ----------------------------------------------------------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------------------------------------------------------


def main():
    t_ini = time.time()
    parser = argparse.ArgumentParser(description="Migrate ChEMBL data from the WebServices to Elastic Search")
    parser.add_argument("--delete_indexes",
                        dest="delete_indexes",
                        help="Delete indexes if they exist already in the elastic cluster.",
                        action="store_true",)
    parser.add_argument("-A", "--all",
                        dest="migrate_all",
                        help="Migrate all the data in the WebServices, "
                             "if missing defaults to only 1000 records per resource.",
                        action="store_true",)
    parser.add_argument("--generate_mappings",
                        dest="generate_mappings",
                        help="Generate elastic search mapping skeleton files without migrating",
                        action="store_true",)
    parser.add_argument("--host",
                        dest="es_host",
                        help="Elastic Search Hostname or IP address.",
                        default="localhost")
    parser.add_argument("--user",
                        dest="es_user",
                        help="Elastic Search username.",
                        default=None)
    parser.add_argument("--password",
                        dest="es_password",
                        help="Elastic Search username password.",
                        default=None)
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
    parser.add_argument("--create_alias",
                        dest="create_alias",
                        help="If included will create alias for the configured resources.",
                        action="store_true",)
    args = parser.parse_args()

    if args.create_alias:
        resources_description.ResourceDescription.create_all_aliases(
            args.es_host, args.es_port, args.es_user, args.es_password
        )
        sys.exit(0)

    es_util.setup_connection(args.es_host, args.es_port, args.es_user, args.es_password)

    if not es_util.ping():
        print("ERROR: Can't ping the elastic search server.", file=sys.stderr)
        sys.exit(1)

    selected_resources = None
    if args.ws_resource:
        selected_resources = args.ws_resource.split(',')

    if args.generate_mappings:
        migration_common.generate_mappings_for_resources(selected_resources)
        return

    migration_common.DELETE_AND_CREATE_INDEXES = args.delete_indexes
    if migration_common.DELETE_AND_CREATE_INDEXES:
        if not query_yes_no("This procedure will delete and create all indexes again in the server.\n"
                            "Do you want to proceed?", default="no"):
            return

    es_util.bulk_submitter.start()

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
                es_util.get_idx_count(migration_common.get_index_name(res_i)),
                migration_common.MIG_TRIED_COUNT[res_i],
                migration_common.MIG_TOTAL[res_i])
            )
    glados.es.ws2es.progress_bar_handler.write_after_progress_bars()

    total_time = time.time() - t_ini
    sec = timedelta(seconds=total_time)
    d = datetime(1, 1, 1) + sec

    migration_common.MIG_LOG.info(
        "Finished in: {0} Day(s), {1} Hour(s), {2} Minute(s) and {3} Second(s)"
        .format(d.day - 1, d.hour, d.minute, d.second)
    )


if __name__ == "__main__":
    main()
