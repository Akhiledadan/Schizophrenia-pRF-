# pRFModel_schizophrenia
Used population Receptive Field (pRF) models to study the neural mechanism underlying visual hallucinations in psychotic 
disorders

Data analysis scripts for the project - "Do altered population receptive field properties underly visual hallucinations in 
people with psychotic disorder?"

Compared 2 D gaussian pRF model (Dumoulin and Wandell, 2008) and Difference of Gaussians (DoG) (Zuiderbaan et al.,2012) model 
parameters between 14 schizophrenia patients with hallucination, 11 schizophrenia patients with hallucination and 10 healthy controls. 

Used 6 metrics for the comparison - 
                                    
                                    2D Gaussian model : full width half max                                   
                                    
                                    DoG model         : full width half max,
                                                        Surround size of DoG,
                                                        Suppression index,
                                                        Sigma of positive gaussian,
                                                        Sigma of negative gaussian.

To run the code:

1) Run the models (1 D Gaussian and DOG) using SZ_mrV.m function from vistaSession/<subject number> folder.

2) Use SZ_runAll.m script for analyzing the model parameters and creating the figures 
shown in the manuscript. 

3) Use SZ_statsRunAll.m function for running the statistical analysis.   

