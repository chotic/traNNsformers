%% Runs different datasets - MNIST, SVHN and CIFAR-10 with their respective nn setups and records the results
clear ; close all; clc
warning('off','all')

dataset_path = ['/home/min/a/aankit/AA/ReSpArch-SpintronicSNNProcessor_DAC_2017/' ...
                'Matlab/spiking_relu_conversion-master/dlt_cnn_map_dropout_nobiasnn/data/%s_uint8.mat'];
            
dirspec = 'output/%s';
epochs_mnist = 40;

%%  MNIST
data_name = 'mnist';
epochs = 40;
prune_slowdown = epochs_mnist / epochs;
net = [784, 1200, 1200, 10];
dataset_pathid = sprintf (dataset_path, data_name);
mkdir (sprintf (dirspec, data_name));

run_fcn (data_name, dataset_pathid, net, epochs, prune_slowdown)

%% SVHN
data_name = 'svhn';
epochs = 80;
prune_slowdown = epochs_mnist / epochs;
net = [1024, 1200, 1200, 10];
dataset_pathid = sprintf (dataset_path, data_name);
mkdir (sprintf (dirspec, data_name));

run_fcn (data_name, dataset_pathid, net, epochs, prune_slowdown)

%% CIFAR10
data_name = 'cifar10';
epochs = 120;
prune_slowdown = epochs_mnist / epochs;
net = [1024, 1200, 1200, 10];
dataset_pathid = sprintf (dataset_path, data_name);
mkdir (sprintf (dirspec, data_name));

run_fcn (data_name, dataset_pathid, net, epochs, prune_slowdown)




