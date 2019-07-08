import argparse
import glados.es.ws2es.es_util as es_util
import glados.es.ws2es.signal_handler as signal_handler
import glados.es.ws2es.denormalization.mol_file_helper as mol_file_helper
from glados.es.ws2es.denormalization.activity_handler import ActivityDenormalizationHandler
from glados.es.ws2es.denormalization.atc_class_handler import ATCClassDenormalizationHandler
from glados.es.ws2es.denormalization.assay_handler import AssayDenormalizationHandler
from glados.es.ws2es.denormalization.binding_site_handler import BindingSiteHandler
from glados.es.ws2es.denormalization.compound_handler import CompoundDenormalizationHandler
from glados.es.ws2es.denormalization.cell_handler import CellDenormalizationHandler
from glados.es.ws2es.denormalization.compound_record_handler import CompoundRecordDenormalizationHandler
from glados.es.ws2es.denormalization.document_handler import DocumentDenormalizationHandler
from glados.es.ws2es.denormalization.document_similarity_handler import DocumentSimilarityHandler
from glados.es.ws2es.denormalization.drug_handler import DrugDenormalizationHandler
from glados.es.ws2es.denormalization.drug_indication_handler import DrugIndicationDenormalizationHandler
from glados.es.ws2es.denormalization.metabolism_handler import MetabolismDenormalizationHandler
from glados.es.ws2es.denormalization.mechanism_handler import MechanismDenormalizationHandler
from glados.es.ws2es.denormalization.organism_handler import OrganismDenormalizationHandler
from glados.es.ws2es.denormalization.protein_class_handler import ProteinClassDenormalizationHandler
from glados.es.ws2es.denormalization.source_handler import SourceDenormalizationHandler
from glados.es.ws2es.denormalization.target_component_handler import TargetComponentDenormalizationHandler
from glados.es.ws2es.denormalization.target_prediction_handler import TargetPredictionDenormalizationHandler
from glados.es.ws2es.denormalization.target_handler import TargetDenormalizationHandler
from glados.es.ws2es.denormalization.tissue_handler import TissueDenormalizationHandler

__author__ = 'jfmosquera@ebi.ac.uk'


# ----------------------------------------------------------------------------------------------------------------------
# Denormalization
# ----------------------------------------------------------------------------------------------------------------------

def denormalize_all_but_activity():
    mol_file_helper.pre_cache_sdf_files()
    source_dh = SourceDenormalizationHandler()
    source_dh.scan_data_from_es()
    source_dh.save_denormalization()

    organism_dh = OrganismDenormalizationHandler()
    organism_dh.scan_data_from_es()
    organism_dh.save_denormalization()
    organism_dh.complete_data_from_assay_and_target()

    atc_class_dh = ATCClassDenormalizationHandler()
    atc_class_dh.scan_data_from_es()
    atc_class_dh.save_denormalization()

    target_pre_dh = TargetDenormalizationHandler()
    target_pre_dh.scan_data_from_es()

    target_prediction_dh = TargetPredictionDenormalizationHandler(target_dh=target_pre_dh)
    target_prediction_dh.scan_data_from_es()
    target_prediction_dh.save_denormalization()
    # Scan again to load the target pref name for other denormalizers
    target_prediction_dh.scan_data_from_es()

    protein_class_dh = ProteinClassDenormalizationHandler()
    protein_class_dh.scan_data_from_es()
    protein_class_dh.save_denormalization()

    drug_indication_dh = DrugIndicationDenormalizationHandler()
    drug_indication_dh.scan_data_from_es()
    drug_indication_dh.save_denormalization()

    drug_dh = DrugDenormalizationHandler()
    drug_dh.scan_data_from_es()
    drug_dh.save_denormalization()

    cell_dh = CellDenormalizationHandler(organism_dh=organism_dh)
    cell_dh.scan_data_from_es()
    cell_dh.save_denormalization()

    compound_record_dh = CompoundRecordDenormalizationHandler(source_dh=source_dh)
    compound_record_dh.scan_data_from_es()
    compound_record_dh.save_denormalization()

    assay_document_dh = DocumentDenormalizationHandler()
    assay_document_dh.scan_data_from_es()

    assay_dh = AssayDenormalizationHandler(
        complete_from_assay=True, organism_dh=organism_dh, source_dh=source_dh, document_dh=assay_document_dh
    )
    assay_dh.scan_data_from_es()
    # Save the denormalization on the next step
    # assay_dh.save_denormalization()

    compound_dh = CompoundDenormalizationHandler(
        complete_x_refs=True, atc_dh=atc_class_dh, tp_dh=target_prediction_dh
    )
    compound_dh.scan_data_from_es()
    compound_dh.save_denormalization()

    document_dh = DocumentDenormalizationHandler(assay_dh=assay_dh, source_dh=source_dh)
    document_dh.scan_data_from_es()
    document_dh.save_denormalization()

    doc_similarity_dh = DocumentSimilarityHandler(document_dh)
    doc_similarity_dh.scan_data_from_es()
    doc_similarity_dh.save_denormalization()

    metabolism_dh = MetabolismDenormalizationHandler(compound_dh=compound_dh)
    metabolism_dh.scan_data_from_es()
    metabolism_dh.save_denormalization()

    target_dh = TargetDenormalizationHandler(complete_x_refs=True, organism_dh=organism_dh, tp_dh=target_prediction_dh)
    target_dh.scan_data_from_es()
    target_dh.save_denormalization()

    target_component_dh = TargetComponentDenormalizationHandler(complete_x_refs=True,
                                                                protein_class_dn_handler=protein_class_dh)
    target_component_dh.scan_data_from_es()
    target_component_dh.save_denormalization()

    tissue_dh = TissueDenormalizationHandler(assay_dh=assay_dh, organism_dh=organism_dh)
    tissue_dh.scan_data_from_es()
    tissue_dh.save_denormalization()


def denormalize_unichem():
    c_dh = CompoundDenormalizationHandler()
    c_dh.scan_data_from_es()
    c_dh.complete_unichem_data()


def denormalize_activity():
    assay_dh = AssayDenormalizationHandler()
    assay_dh.scan_data_from_es()

    compound_dh = CompoundDenormalizationHandler()
    compound_dh.scan_data_from_es()

    organism_dh = OrganismDenormalizationHandler()
    organism_dh.scan_data_from_es()

    source_dh = SourceDenormalizationHandler()
    source_dh.scan_data_from_es()

    target_dh = TargetDenormalizationHandler()
    target_dh.scan_data_from_es()

    protein_class_dh = ProteinClassDenormalizationHandler()
    protein_class_dh.scan_data_from_es()

    target_component_dh = TargetComponentDenormalizationHandler(protein_class_dn_handler=protein_class_dh)
    target_component_dh.scan_data_from_es()

    compound_record_dh = CompoundRecordDenormalizationHandler()
    compound_record_dh.scan_data_from_es()

    activity_dh = ActivityDenormalizationHandler(
        complete_from_activity=True, assay_dh=assay_dh,
        compound_dh=compound_dh, organism_dh=organism_dh,
        source_dh=source_dh, target_dh=target_dh,
        target_component_dh=target_component_dh,
        compound_record_dh=compound_record_dh
    )
    activity_dh.scan_data_from_es()

    activity_dh.complete_compound()
    assay_dh.complete_cell_n_tissue(
        assay_2_compound=activity_dh.assay_2_compound, ac_dh_assay_dict=activity_dh.assay_dict
    )

    # Save denormalization after the completion methods have run
    activity_dh.save_denormalization()
    assay_dh.save_denormalization()


def denormalize_compound_hierarchy():
    compound_dh = CompoundDenormalizationHandler(analyze_hierarchy=True)
    compound_dh.scan_data_from_es(include_metadata=True)
    compound_dh.molecule_family_desc.print_tree()
    compound_dh.complete_hierarchy_data()

    mechanism_dh = MechanismDenormalizationHandler(compound_families_dir=compound_dh.molecule_family_desc)
    mechanism_dh.scan_data_from_es()

    drug_indication_dh = DrugIndicationDenormalizationHandler(compound_families_dir=compound_dh.molecule_family_desc)
    drug_indication_dh.scan_data_from_es()


def denormalize_mechanism_and_drug_indication():
    compound_dh = CompoundDenormalizationHandler(analyze_hierarchy=True)
    compound_dh.scan_data_from_es(include_metadata=True)
    compound_dh.molecule_family_desc.print_tree()

    mechanism_dh = MechanismDenormalizationHandler(
        compound_families_dir=compound_dh.molecule_family_desc
    )
    mechanism_dh.scan_data_from_es(include_metadata=True)
    mechanism_dh.save_denormalization()

    drug_ind_dh = DrugIndicationDenormalizationHandler(
        compound_families_dir=compound_dh.molecule_family_desc
    )
    drug_ind_dh.scan_data_from_es(include_metadata=True)
    drug_ind_dh.save_denormalization()

# ----------------------------------------------------------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------------------------------------------------------


def main():
    parser = argparse.ArgumentParser(description="Denormalize ChEMBL data existing in Elastic Search")
    parser.add_argument("--host",
                        dest="es_host",
                        help="Elastic Search Hostname or IP address.",
                        default="localhost")
    parser.add_argument("--port",
                        dest="es_port",
                        help="Elastic Search port.",
                        default=9200)
    parser.add_argument("--unichem",
                        dest="denormalize_unichem",
                        help="If included will denormalize the unichem related data.",
                        action="store_true",)
    parser.add_argument("--activity",
                        dest="denormalize_activity",
                        help="If included will denormalize the configured activity related data.",
                        action="store_true",)
    parser.add_argument("--compound-hierarchy",
                        dest="denormalize_compound_hierarchy",
                        help="If included will denormalize the Compound Hierarchy data.",
                        action="store_true",)
    parser.add_argument("--mechanism-and-drug-indication",
                        dest="denormalize_mechanism_and_drug_indication",
                        help="If included will denormalize the Mechanism and Drug Indication data.",
                        action="store_true",)
    args = parser.parse_args()

    es_util.setup_connection(args.es_host, args.es_port)

    signal_handler.add_termination_handler(es_util.stop_scan)

    if args.denormalize_compound_hierarchy:
        denormalize_compound_hierarchy()
    elif args.denormalize_activity:
        denormalize_activity()
    elif args.denormalize_unichem:
        denormalize_unichem()
    elif args.denormalize_mechanism_and_drug_indication:
        denormalize_mechanism_and_drug_indication()
    else:
        denormalize_all_but_activity()


if __name__ == "__main__":
    main()
