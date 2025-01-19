imageFolder = fullfile('images');
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', 'IncludeSubfolders',true);
alex = alexnet;
layers = alex.Layers;
layers(23) = fullyConnectedLayer(2);
layers(25) = classificationLayer;
[trainingSet, testSet] = splitEachLabel(imds,3/4, 'randomize');
imageSize = alex.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');
myOptions = trainingOptions("sgdm","InitialLearnRate",0.0005,"MaxEpochs",15,"Plots","training-progress","MiniBatchSize",256);
myNet = trainNetwork(augmentedTrainingSet,layers,myOptions);
predictedLabels = classify(myNet,augmentedTestSet);
accuracy = mean(predictedLabels == testSet.Labels);
disp(['accuracy = ',num2str(accuracy)]);