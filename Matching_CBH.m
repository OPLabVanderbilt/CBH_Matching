%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Same Different Matching Test with Cars, Birds, Houses
% Car images from 2008

% Rankin McGugin
% Nov 2013 (Planes taken out by M Sunday 2015)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%3 categories
%calls scrambled function for mask
%call runVET_CBH.m



clear all;
Screen('Preference', 'SkipSyncTests',1); % for macbook pro only
commandwindow;
seed = ClockRandSeed;
spaceBar = KbName('space');


%setting up keyboards
devices = PsychHID('Devices'); 
kbs = find([devices(:).usageValue] == 6); 
usethiskeyboard = kbs(end);


repeat=1;
while (repeat)
    prompt= {'Subject Number','Subject Initials','Age','Sex (m/f)', 'Race', 'Handedness (r/l)'};
    defaultAnswer={'1000','abc','18', 'f', 'c', 'r'};
    answer=inputdlg(prompt,'Subject information',1, defaultAnswer);
    [subjno,subjini,age,sex,race,hand]=deal(answer{:});
    if isempty(str2num(subjno)) || ~isreal(str2num(subjno))
        h=errordlg('Subject Number must be an integers','Input Error'); repeat=1; uiwait(h);
    else
        fileName=['CBH_Data/Exp_Matching_' subjno '_' subjini '.txt'];
        if exist(fileName)~=0
            button=questdlg('Overwrite data?');
            if strcmp(button,'Yes'); repeat=0; end
        else
            repeat=0;
        end
    end
end

dataFile=fopen(fileName, 'a');
fprintf(dataFile,('\nsubjno\tsubjini\tage\tsex\trace\thand\trunnb\tblocknb\ttrial_no\tcategory\tstimulus1\tstimulus2\tcorrres\tsubresp\tacc\trt'));

% Set Timing
S1Duration = 1; S2Duration = 5; FixmaskDuration = .5;

HideCursor; StartExpt = GetSecs;
bcolor = [0 0 0]; white = [255 255 255];
textwidth = 100; textheight = 100;
screenNumber=max(Screen('Screens'));
[w, screenRect]=Screen('OpenWindow',screenNumber, bcolor, [], 32, 2);
Screen('TextSize', w, 18);
midWidth=round(RectWidth(screenRect)/2); midLength=round(RectHeight(screenRect)/2); % get center coordinates
Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);


%instructions
not1= 'In this experiment, you will try to match pictures of cars, birds, and houses as fast as you can.';
not2= 'On each trial, you will first see a picture of a car, bird, or house,';
not3= 'which will disappear after 1 sec, and be followed by an irrelevant scrambled image that you can ignore.';
not4= 'A 2nd car, bird, or house will then appear.';
not5= 'You should press "s" for SAME if the second image is the SAME as the first';
not6= 'and "d" for DIFFERENT if the second image is DIFFERENT from the first.';
not7= 'Press the space bar to continue.';

Screen('TextSize', w, 24);
Screen('DrawText', w, not1, 100, 100, 255); Screen('DrawText', w, not2, 100, 150, 255);
Screen('DrawText', w, not3, 100, 190, 255); Screen('DrawText', w, not4, 100, 280, 255);
Screen('DrawText', w, not5, 100, 310, 255); Screen('DrawText', w, not6, 100, 340, 255);
Screen('DrawText', w, not7, 100, 370, 255);
Screen('Flip', w);

touch=0;
while ~touch
    [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
    if keyCode(spaceBar); break; else touch=0; end
end
while KbCheck; end

Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
not8= 'This part of the experiment lasts about 30 minutes.';
not9= 'You will see cars, birds, and houses in separate blocks of trials and will always be told which category is coming.';
not10= 'In all cases, you should try to make as few mistakes as possible';
not11= 'but YOU SHOULD ALWAYS TRY TO RESPOND AS FAST AS YOU CAN';
not12= 'It is very important that you try to do your best with all categories -- cars, birds, and houses.';
not13= 'If you take more than 5 secs to respond, the trial will time out.';
not14= 'Press the space bar to begin a few practice trial.';

Screen('TextSize', w, 24);
Screen('DrawText', w, not8, 100, 100, 255); Screen('DrawText', w, not9, 100, 150, 255);
Screen('DrawText', w, not10, 100, 190, 255); Screen('DrawText', w, not11, 100, 240, 255);
Screen('DrawText', w, not12, 100, 310, 255); Screen('DrawText', w, not13, 100, 340, 255);
Screen('DrawText', w, not14, 100, 370, 255);
Screen('Flip', w); WaitSecs(.5);

touch=0;
while ~touch
    [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
    if keyCode(spaceBar); break; else touch=0; end
end
while KbCheck; end

Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);

%Load design matrix
[runnb blknb category tottrialnumb blktrialnumb stimulus1 stimulus2 corrresp]=textread('DesignMatrix_Matching.txt','%u %u %s %u %u %s %s %s');

for j=1:numel(tottrialnumb)
    
    if strcmp(category(j),'Cars')
        imfolder='Matching/Cars_matching/';
        maskimage = stimulus1{randi([1 60],1,1)};
    elseif strcmp(category(j),'Birds')
        imfolder='Matching/Birds_matching/';
        maskimage = stimulus1{randi([61 120],1,1)};
    elseif strcmp(category(j),'Planes')
        imfolder='Matching/Houses_matching/';
        maskimage = stimulus1{randi([121 180],1,1)};
    end
        
    %practice + category-specific instructions
    if tottrialnumb(j)==0
        
        practice=find(tottrialnumb==0);
        Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        if strcmp(category(j),'Cars')
            not15= 'When matching cars you should respond "SAME"only if the two cars are the same make and model (BUT they may be different years).';
            not16= 'It may be difficlut sometimes because the makes and models may be very similar.';
            prac=practice(1:4);
        elseif strcmp(category(j),'Birds')
            not15= 'When matching birds, you should respond "SAME" only if the two birds are of the same species.';
            not16= 'It may be difficlut sometimes because the birds are all from similar passerine species.';
            prac=practice(5:8);
        elseif strcmp(category(j),'Houses')
            not15= 'When matching planes you should respond "SAME"only if the two houses are the exact same house.';
            not16= 'The pictures are taken from different perspectives with different lighting conditions.';
            prac=practice(9:12);
        end
        not17= 'YOU SHOULD ALWAYS TRY TO RESPOND AS FAST AS YOU CAN!!!!';
        not18= 'Press the space bar to try some PRACTICE trials.';
        
        if tottrialnumb(j)==0 && tottrialnumb(j+1)==0 && tottrialnumb(j+2)==0 && tottrialnumb(j+3)==0
            Screen('TextSize', w, 24);
            Screen('DrawText', w, not15, 100, 100, 255); Screen('DrawText', w, not16, 100, 150, 255);
            Screen('DrawText', w, not17, 100, 310, 255); Screen('DrawText', w, not18, 100, 340, 255);
            Screen('Flip', w); WaitSecs(.5);
            
            touch=0;
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end
            while KbCheck; end
        end
        
        Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        Screen('DrawText', w, '+', midWidth, midLength, white); Screen('Flip', w);
        WaitSecs(FixmaskDuration);
        Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        
        S1 = imread([imfolder stimulus1{j},'.jpg'],'jpg');
        S2 = imread([imfolder stimulus2{j},'.jpg'],'jpg');
        
        maskim = imread([imfolder maskimage '.jpg'],'jpg');
        mask = Scramble(maskim,16);
        
        Screen('PutImage', w, S1); Screen('Flip', w);  WaitSecs(S1Duration);
        Screen('PutImage', w, mask); Screen('Flip', w); WaitSecs(FixmaskDuration);
        Screen('PutImage', w, S2); Screen('Flip', w);
        
        tempTime = 0; rt = 0; keyIsDown = 0; GradedRes = 0;
        RTstart = GetSecs;
        
        while tempTime < S2Duration;
            tempTime = GetSecs - RTstart;
            [keyIsDown,secs,keyCode]=KbCheck;
            if keyCode(kbName('s'));   % "s"
                break
            elseif keyCode(kbName('d'));  % "d"
                break
            end
        end
        while KbCheck; end
        
        %for feedback
        if strcmp(corrresp(j),'same');
            if keyCode(kbname('s')); acc = 1;
            elseif keyCode(kbName('d')); acc = 0;
            else acc=0;
            end
        elseif strcmp(corrresp(j),'diff');
            if keyCode(kbName('s')); acc = 0;
            elseif keyCode(kbName('d')); acc = 1;
            else acc=0;
            end
        end
        
        if acc==1
            notC= 'CORRECT ANSWER!!!!!';
            Screen('DrawText', w, notC, 850, 310, 255); Screen('Flip', w); WaitSecs(.5);
        elseif acc==0
            notI= 'INCORRECT';
            Screen('DrawText', w, notI, 900, 310, 255); Screen('Flip', w); WaitSecs(.5);
        end
        
        if tottrialnumb(j)==0 && tottrialnumb(j+1)~=0
            notP1= 'This is the end of the practice trials for this category.';
            notP2= 'As you can see, the task is simple but some decisions may be more difficult than others.';
            notP3= 'It is important that you give your best guess on each trial';
            notP4= 'even if you feel that you do not know the correct answer.';
            notP5= 'Press the space bar to begin the real trials of the experiment.';
            
            Screen('TextSize', w, 24);
            Screen('DrawText', w, notP1, 100, 100, 255); Screen('DrawText', w, notP2, 100, 150, 255);
            Screen('DrawText', w, notP3, 100, 190, 255); Screen('DrawText', w, notP4, 100, 240, 255);
            Screen('DrawText', w, notP5, 100, 310, 255);
            Screen('Flip', w); WaitSecs(.5);
            
            touch=0;
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end
            while KbCheck; end
            Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        end
        
        %real trials
    elseif tottrialnumb(j)~=0
        
        if tottrialnumb(j)==1
            if blktrialnumb(j)==1 && strcmp(category(j),'Cars')
                notB1= 'The next block will show CARS.';
                maskimage = stimulus1{randi([1 60],1,1)};
            elseif blktrialnumb(j)==1 && strcmp(category(j),'Birds')
                notB1= 'The next block will show BIRDS.';
                maskimage = stimulus1{randi([61 120],1,1)};
            elseif blktrialnumb(j)==1 && strcmp(category(j),'Houses')
                notB1= 'The next block will show HOUSES.';
                maskimage = stimulus1{randi([121 180],1,1)};
            end
            notS= 'Press the space bar to begin.';
            
            Screen('TextSize', w, 32);
            Screen('DrawText', w, notB1, 800, 200, 255);
            Screen('DrawText', w, notS, 800, 410, 255);
            Screen('Flip', w); WaitSecs(.5);
            touch=0;
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end
            while KbCheck; end
            Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        end
        
        Screen('DrawText', w, '+', midWidth, midLength, white); Screen('Flip', w);
        WaitSecs(FixmaskDuration);
        Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        
        S1 = imread([imfolder stimulus1{j},'.jpg'],'jpg');
        S2 = imread([imfolder stimulus2{j},'.jpg'],'jpg');
        maskim = imread([imfolder maskimage '.jpg'],'jpg');
        mask = Scramble(maskim,16);
        
        Screen('PutImage', w, S1); Screen('Flip', w);  WaitSecs(S1Duration);
        Screen('PutImage', w, mask); Screen('Flip', w); WaitSecs(FixmaskDuration);
        Screen('PutImage', w, S2); Screen('Flip', w);
        
        tempTime = 0; rt = 0; keyIsDown = 0; GradedRes = 0;
        RTstart = GetSecs;
        
        while tempTime < S2Duration;
            tempTime = GetSecs - RTstart;
            [keyIsDown,secs,keyCode]=KbCheck;
            if keyCode(kbName('s'));
                break
            elseif keyCode(kbName('d'));
                break
            end
        end
        while KbCheck; end
        
        rt = GetSecs-RTstart; rt = (rt)*1000;
        
        if strcmp(corrresp(j),'same');
            if keyCode(kbname('s')); acc = 1;
            elseif keyCode(kbName('d')); acc = 0;
            end
        elseif strcmp(corrresp(j),'diff');
            if keyCode(kbName('s')); acc = 0;
            elseif keyCode(kbName('d')); acc = 1;
            end
        end
        
        
        Screen('FillRect', w, bcolor, screenRect); Screen('Flip', w);
        
%         fprintf(dataFile,['\n%s\t%s\t%u\t%u\t%u\t%s'],...
%             subjno,subjini,runnb(j),blknb(j),j,category{j});

        fprintf(dataFile,'\n%s\t%s\t%s\t%s\t%s\t%s\t%u\t%u\t%u\t%s\t%s\t%s\t%s\t%d\t%f',...
            subjno,subjini,age,sex,race,hand,runnb(j),blknb(j),j,category{j},stimulus1{j},stimulus2{j},corrresp{j},acc,rt);
        
        
    end
end 
 

%%%%%%%%
runVET_CBPH.m


