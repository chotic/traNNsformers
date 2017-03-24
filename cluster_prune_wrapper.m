function nn = cluster_prune_wrapper( nn, last_err, train_x, train_y )
%CLUSTER_PRUNE_WRAPPER wraps around the cluster_prune script to keep doing
%cluster_prune with increasing threshold until accuracy starts dropping.

% Cluster_prune incrementally (after training finishes) to prune while constraining the accuracy loss
% - note this isn't accompanied by any weight training now.
global fid;

% for debug only
for i = 1:nn.n-1
    prunestats = 100* sum(sum(nn.map{i}))/(size(nn.map{i},1) * size(nn.map{i},2));
    fprintf(fid, 'Layer %d Pruned before cluster pruning : %2.2f\n', i, 100-prunestats); % only for debug
end

test_acc_base = (1-last_err)*100;
while (true)
    disp('Entering loop...\n')
    wt_restore = nn.W;
    map_restore = nn.map;
    nn = cluster_prune(nn);
%     train_x = train_x((1:1000),:); % reduce the no. of training samples being used for validation of cluster pruning
%     train_y = train_y((1:1000),:);
    [er, ~] = nntest(nn, train_x, train_y);
    test_acc_curr = (1-er)*100;
    fprintf('test_acc_base-test_acc_curr: %f\n', test_acc_base-test_acc_curr)
    fprintf('base_acc: %f\n', test_acc_base)
    fprintf('base_curr: %f\n', test_acc_curr)
    fprintf('nn.cluster_prune_factor %f\n', nn.cluster_prune_factor)

    if ((nn.cluster_prune_factor > 1) || (test_acc_base-test_acc_curr) >= nn.cluster_prune_acc_loss)
        nn.map = map_restore;
        nn.W = wt_restore;
        fprintf(fid, 'breaking off the cluster_prune loop\n');
        break;
    end
    nn.cluster_prune_factor = nn.cluster_prune_factor + 0.01;
end

% for debug only
for i = 1:nn.n-1
    prunestats = 100* sum(sum(nn.map{i}))/(size(nn.map{i},1) * size(nn.map{i},2));
    fprintf(fid, 'Layer %d Pruned after cluster pruning : %2.2f\n', i, 100-prunestats); % only for debug
end

fprintf(fid, 'Accuracy on training set after this group prune: %2.2f%%.\n', (1-er)*100);

% [er, train_bad] = nntest(nn, train_x, train_y);
% fprintf(fid, 'TRAINING Accuracy after after all group prunes: %2.2f%%.\n', (1-er)*100);
% [er, bad] = nntest(nn, test_x, test_y);
% fprintf(fid, 'Test Accuracy after all group prunes: %2.2f%%.\n', (1-er)*100);

% % Plot the final cluster quality histograms - after group_prune
% if_hist = 1;
% if (nn.prunemode == 2)
%     % find the updated clustering statistics & plot them (histograms)
%     figure(2),
%     for i = 1:nn.n-1
%         prunestats = 100* sum(sum(nn.map{i}))/(size(nn.map{i},1) * size(nn.map{i},2));
%         fprintf(fid, 'Pruned percentage of Layer %d Post-Group Prune: %2.2f%%.\n', i, 100-prunestats);
%         subplot(1,nn.n-1,i),
%         % final connectivity matrix - logic or of cmap and pmap
%         conn_matrix = logical(nn.cmap{i}) | logical(nn.pmap{i});
%         analyse_cluster(nn.clusters{i}, conn_matrix, if_hist);
%     end
% end

end

