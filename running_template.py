import h5py
import tifffile as tiff
from keras.backend.common import _UID_PREFIXES

from cnn_functions import nikon_getfiles, get_image, run_models_on_directory, get_image_sizes, segment_nuclei, segment_cytoplasm, dice_jaccard\
_indices
from model_zoo import sparse_bn_feature_net_61x61 as cyto_fn
from model_zoo import sparse_bn_feature_net_61x61 as nuclear_fn

import time
import os
import numpy as np
import sys

t0 = time.clock()
"""                                                                                                                                            
Load data                                                                                                                                      
"""

mainfolder = '/hdd1/dbess/DockerDeepCell/DeepCell/validation_data/KC913/'
cyto_channel_names =['phase']
nuclear_channel_names = []

trained_network_cyto_directory = '/hdd1/dbess/DockerDeepCell/DeepCell/trained_networks/KC865_single_set/'
cyto_prefix = "2018-07-17_KC865_61x61_bn_feature_net_61x61_"
#cyto_prefix = "2016-10-30_pombe_phase_half_2_61x61_bn_feature_net_61x61_"                                                                     
win_cyto = 30

folders= os.walk(mainfolder).next()[1]

for f in folders:
   if not os.path.exists(os.path.join(mainfolder, f, 'Output')):
        os.makedirs(os.path.join(mainfolder, f, 'Output'))


for f in folders:

    if os.path.isdir(os.path.join(mainfolder, f,'Output')):
        numfiles = len(os.listdir(os.path.join(mainfolder, f,'Output')));
        if numfiles == 0:
                        print f
                        direc_name = os.path.join(mainfolder, f)
                        data_location = direc_name
                        cyto_location = os.path.join(direc_name, 'Output')
                        image_size_x, image_size_y = get_image_sizes(data_location,cyto_channel_names)
                        #image_size_x /= 4                                                                                                     
                        #image_size_y /= 4                                                                                                     

                        """                                                                                                                    
                        Define model                                                                                                           
                        """

                        list_of_cyto_weights = []
                        for j in xrange(1):
                                cyto_weights = os.path.join(trained_network_cyto_directory,  cyto_prefix + str(j) + ".h5")
                                list_of_cyto_weights += [cyto_weights]


                        """                                                                                                                    
                        Run model on directory                                                                                                 
                        """

                        cytoplasm_predictions = run_models_on_directory(data_location, cyto_channel_names, cyto_location, n_features = 3, mode\
l_fn = cyto_fn,
                                list_of_weights = list_of_cyto_weights, image_size_x = image_size_x, image_size_y = image_size_y,
                                                                        win_x = win_cyto, win_y = win_cyto, std = False, split = True, save = \
True)



print time.clock()-t0

