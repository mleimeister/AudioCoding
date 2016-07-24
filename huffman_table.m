function y = huffman_table(values)
% Computes a huffman codebook for a given vector of values.

N = length(values);

% compute the probabilities of the values
probs = zeros(1,N);

for k=1:N
        v = (values==values(k));
        probs(k) = sum(v);          
end

% make the values unique and save the indices in vector n
[values,n] = unique(values);
% make probabilities correspnd to the values
probs = probs(n);
% normalize the probabilities
probs = probs/sum(probs);

for index = 1:length(probs)
    % cell of codewords to be generated for each unique value
    codewords{index} = [];
    % cell to represent the different nodes during the iteration
    nodes{index} = index;
end

% iterate until all sets have been reduced to one (the root of the tree)
while length(nodes) > 1
    
    % determine which nodes on the current level have the lowest probabilities
    [~, indices] = sort(probs);

    % find set with the lowest probability
    left_child_node = nodes{indices(1)};
    left_child_prob = probs(indices(1));
    
    for index = 1:length(left_child_node)
        % put a zero to each codeword already in the set, i.e. branch to
        % the left in the tree
        codewords{left_child_node(index)} = [codewords{left_child_node(index)}, 0];       
    end
    
    % find set with the second lowest probability
    right_child_node = nodes{indices(2)};
    right_child_prob = probs(indices(2));
    
    for index = 1:length(right_child_node)
        % put a one to each codeword already in the set, i.e. branch to the
        % right in the tree
        codewords{right_child_node(index)} = [codewords{right_child_node(index)}, 1];       
    end
    
    % merge the two sets into one new set with the sum of the probabilities
    nodes(indices(1:2)) = [];
    nodes{length(nodes)+1} = [left_child_node, right_child_node];
   
    probs(indices(1:2)) = [];
    probs(length(probs)+1) = left_child_prob + right_child_prob;
end

% the final codewords are the created codewords in bit reversed order, i.e.
% going from the root of the tree to the leafs
for index = 1:length(codewords)
    codewords{index}=codewords{index}(end:-1:1);
end

% store values and codewords as a whole dictionary in a cell array to meet 
% the requirements of the huffmanenco/huffmandeco function
y = [num2cell(values)', codewords'];
