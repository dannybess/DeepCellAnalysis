clearvars -except pombe frame;
F = length(frame);

% Min number of frames for a good trajectory?
minfr = 5;

i = 0;

% Loop over all frames
for fr=2:F-1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 1. Find related cell in previous frame - if there is none, index = 1
    
    % Loop over all cells in frame
    for c=1:length(frame(fr).object)
        clearvars rel;


        for k=1:length(frame(fr-1).object)
            R = frame(fr-1).object(k).relation;
            if mean(size(R))==1

                rel(k) = R;
            end

        end

        % Proceed only if there is a relation to the previous frame
        if exist('rel')
            % Test relationship
            rel = rel';
            %x = find(rel==c);
        else
            rel = [];
        end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % 2. Is this the first frame? If so, will run through entire 
            % trajectories from current frame until last

            j = 0;
            if (sum(rel~=c)==length(rel)) || fr==2
                %disp('yay!');
                % Store first frame of this cell's trajectory
                i = i+1;
                j = j+1;

                TOTALS(i).traj(j) = frame(fr).object(c);
                


                stop = false;
                    % Loop over all further frames
                for s=fr:F-2
                    if ~stop
                        % IS THE NEXT FRAME RELATED?
                        R = frame(s).object(c).relation;
                        if mean(size(R))==1
                            j = j+1;
                            %n = find(rel==c);

                            TOTALS(i).traj(j) = frame(s+1).object(R);
                            
                            c = R;

                            stop = false;
                        else 
                            stop = true;
                        end

                    end


                end

            end
            
            

        
        
        
        
    end


end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOW REMOVE TRAJECTORIES THAT AREN'T LONGER THAN 'min' FRAMES
j = 0;
for s = 1:length(TOTALS)
    if length(TOTALS(s).traj)<minfr
        j = j+1;
        rem_fr(j) = s;
    end
end
if exist('rem_fr')
    TOTALS(rem_fr') = [];
end

