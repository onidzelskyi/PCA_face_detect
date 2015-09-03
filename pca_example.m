function [] = pca_example()
    % Demonstration of PCA in face recognition using by orl face database
    
    % 1. orl face db in current catalog ./orl_faces
    %pca('orl')

    % 2. recognize digits
    % Loads prepare data and test images
    % X (PxD) contain P data images unfolded in rows of D=MxN
    % X_test (TxD) contain T test images unfolded in rows of D=MxN
    %pca('digits')

    % 3. demo mode - display pair of images
    % Loads prepare data and test images
    % X (PxD) contain P data images unfolded in rows of D=MxN
    % X_test (TxD) contain T test images unfolded in rows of D=MxN
    % mu (1xD) mean image for normalization
    % A (PxD) normalized images
    % U (DxD) eigenvectors
    % S (DxD) eigenvalues
    % eigenfaces
    % L (DxK) transform matrix where D>K, K - reduced number of elements
    pca('demo')
end