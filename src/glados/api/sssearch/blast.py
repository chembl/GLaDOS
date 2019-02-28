from urllib.parse import urlencode
from urllib.request import urlopen, Request
from urllib.error import HTTPError
from . import search_manager

BLAST_API_BASE_URL = 'https://www.ebi.ac.uk/Tools/services/rest/ncbiblast'


def queue_blast_job(raw_search_params):

    print('queueing blast job')
    print(raw_search_params)

    run_url = '{}/runfhfhfhfh/'.format(BLAST_API_BASE_URL)
    params = {
        'alignments': '50',
        'database': 'chembl',
        'gapopen': '-1',
        'gapalign': 'true',
        'scores': '50',
        'sequence': '>sp|P35858|ALS_HUMAN Insulin-like growth factor-binding protein complex acid labile subunit OS=Homo sapiens GN=IGFALS PE=1 SV=1 \nMALRKGGLALALLLLSWVALGPRSLEGADPGTPGEAEGPACPAACVCSYDDDADELSVFC\nSSRNLTRLPDGVPGGTQALWLDGNNLSSVPPAAFQNLSSLGFLNLQGGQLGSLEPQALLG\nLENLCHLHLERNQLRSLALGTFAHTPALASLGLSNNRLSRLEDGLFEGLGSLWDLNLGWN\nSLAVLPDAAFRGLGSLRELVLAGNRLAYLQPALFSGLAELRELDLSRNALRAIKANVFVQ\nLPRLQKLYLDRNLIAAVAPGAFLGLKALRWLDLSHNRVAGLLEDTFPGLLGLRVLRLSHN\nAIASLRPRTFKDLHFLEELQLGHNRIRQLAERSFEGLGQLEVLTLDHNQLQEVKAGAFLG\nLTNVAVMNLSGNCLRNLPEQVFRGLGKLHSLHLEGSCLGRIRPHTFTGLSGLRRLFLKDN\nGLVGIEEQSLWGLAELLELDLTSNQLTHLPHRLFQGLGKLEYLLLSRNRLAELPADALGP\nLQRAFWLDVSHNRLEALPNSLLAPLGRLRYLSLRNNSLRTFTPQPPGLERLWLEGNPWDC\nGCPLKALRDFALQNPSAVPRFVQAICEGDDCQPPAYTYNNITCASPPEVVGLDLRDLSEA\nHFAPC\n',
        'matrix':
        'BLOSUM62',
        'dropoff': '0',
        'email': 'dmendez@ebi.ac.uk',
        'align': '0',
        'transltable': '1',
        'gapext': '-1',
        'program': 'blastp',
        'stype': 'protein',
        'filter': 'F',
        'task': 'blastp',
        'exp': '10',
        'compstats': 'F'
    }

    request_data = urlencode(params)

    # r = requests.get(run_url, params=params)
    print('params: ', params)
    print('request_data: ', request_data)
    try:

        req = Request(run_url)
        req_handle = urlopen(req, request_data.encode(encoding=u'utf_8', errors=u'strict'))
        job_id = req_handle.read()
        print('job_id: ', job_id)
        req_handle.close()

        response = {
            'search_id': 'job_id'
        }
        return response

    except HTTPError as ex:

        msg = 'Error while submitting BLAST job:\n{}'.format(repr(ex))
        raise search_manager.SSSearchError(msg)

