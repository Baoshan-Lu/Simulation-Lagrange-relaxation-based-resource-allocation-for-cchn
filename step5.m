%**************************************************************************
% STEP 5: Construct a series of alternating primed and starred zeros as
%         follows.  Let Z0 represent the uncovered primed zero found in Step 4.
%         Let Z1 denote the starred zero in the column of Z0 (if any). 
%         Let Z2 denote the primed zero in the row of Z1 (there will always
%         be one).  Continue until the series terminates at a primed zero
%         that has no starred zero in its column.  Unstar each starred 
%         zero of the series, star each primed zero of the series, erase 
%         all primes and uncover every line in the matrix.  Return to Step 3.
%**************************************************************************

function [M,r_cov,c_cov,stepnum] = step5(M,Z_r,Z_c,r_cov,c_cov)

  zflag = 1;
  ii = 1;
  while zflag 
    % Find the index number of the starred zero in the column
    rindex = find(M(:,Z_c(ii))==1);
    if rindex > 0
      % Save the starred zero
      ii = ii+1;
      % Save the row of the starred zero
      Z_r(ii,1) = rindex;
      % The column of the starred zero is the same as the column of the 
      % primed zero
      Z_c(ii,1) = Z_c(ii-1);
    else
      zflag = 0;
    end
    
    % Continue if there is a starred zero in the column of the primed zero
    if zflag == 1;
      % Find the column of the primed zero in the last starred zeros row
      cindex = find(M(Z_r(ii),:)==2);
      ii = ii+1;
      Z_r(ii,1) = Z_r(ii-1);
      Z_c(ii,1) = cindex;    
    end    
  end
  
  % UNSTAR all the starred zeros in the path and STAR all primed zeros
  for ii = 1:length(Z_r)
    if M(Z_r(ii),Z_c(ii)) == 1
      M(Z_r(ii),Z_c(ii)) = 0;
    else
      M(Z_r(ii),Z_c(ii)) = 1;
    end
  end
  
  % Clear the covers
  r_cov = r_cov.*0;
  c_cov = c_cov.*0;
  
  % Remove all the primes
  M(M==2) = 0;

stepnum = 3;

