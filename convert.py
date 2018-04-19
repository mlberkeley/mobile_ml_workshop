# Modified from https://github.com/r4ghu/iOS-CoreML-MNIST
import coremltools

output_labels = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
scale = 1/255.
coreml_model = coremltools.converters.keras.convert('./mnistCNN.h5',
                                                   input_names='image',
                                                   image_input_names='image',
                                                   output_names='output',
                                                   class_labels=output_labels,
                                                   image_scale=scale)

coreml_model.author = 'YOUR_NAME_HERE'
coreml_model.license = 'MIT'
coreml_model.short_description = 'Model to classify hand written digit'
coreml_model.input_description['image'] = 'Black and white image'
coreml_model.output_description['output'] = 'Predicted digit'

coreml_model.save('mnistCNN.mlmodel')