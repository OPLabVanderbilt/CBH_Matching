%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vanderbilt Expertise Test - Cars, Birds, Planes, Houses

% Rankin McGugin
% Nov 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%immediately follows MatchingMemory.m


warning('off','MATLAB:dispatcher:InexactMatch');  


%setting up keyboards
devices = PsychHID('Devices'); 
kbs = find([devices(:).usageValue] == 6); 
usethiskeyboard = kbs(end);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Open Screens.
bcolor=0;
AssertOpenGL;
ScreenNumber=max(Screen('Screens'));
[w, ScreenRect]=Screen('OpenWindow',ScreenNumber, bcolor, [], 32, 2);
midWidth=round(RectWidth(ScreenRect)/2);
midLength=round(RectHeight(ScreenRect)/2);
Screen('FillRect', w, bcolor);
Screen('Flip',w);    

Screen_X = RectWidth(ScreenRect);
Screen_Y = RectHeight(ScreenRect);
cx = round(Screen_X/2);
cy = round(Screen_Y/2);

ScreenBlank = Screen(w, 'OpenOffScreenWindow', bcolor, ScreenRect);
[oldFontName, oldFontNumber] = Screen(w, 'TextFont', 'Helvetica' );
[oldFontName, oldFontNumber] = Screen(ScreenBlank, 'TextFont', 'Helvetica' );

% Open image file
VETfileName=['ExpertiseData/Exp_Memory_Data/Exp_Memory_' subjno '_' subjini '.txt'];
VETfile=fopen(VETfileName,'w');
fprintf(VETfile,'\nsubjno\tsubjini\tage\tsex\trace\thand\tblknum\ttcat\ttrial\ttarnb\texnb\ttarname\tdist1name\tdist2name\ttarloc\tresp\tfdbk\tac\trt');

% % Begin
% Screen('TextSize', w, 24);
% msg='Please press the space bar again to get started on the next part of the study!';
% Screen('Drawtext', w, msg, 100, 120, 255);
% Screen('Flip', w);
% waitsecs(.25);
% touch=0;
% spaceBar = kbName('space');
% while ~touch
%     [touch,tpress,keycode]=KbCheck;
%     if keycode(spaceBar); break; else touch=0; end
% end
% while KbCheck; end
% Screen('FillRect', w, bcolor); 
% Screen('Flip', w);

try
    commandwindow;  
    
    key1 = KbName('1!'); key2 = KbName('2@'); key3 = KbName('3#');
    key4 = KbName('4$'); key5 = KbName('5%'); key6 = KbName('6^');
    key7 = KbName('7&'); key8 = KbName('8*'); key9 = KbName('9(');
    spaceBar = KbName('space');
    
    wrongkey=MakeBeep(700,0.1);
    
    imfolder = 'Memory/';
    blklength = 48;
    studynb = 12;    %# of identical study reps per cat
    respwindow = 4;  %max resp time of 4s    
        
    %Open data file.
    fprintf(VETfile,'\nratingcat\trating');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Get self ratings.
    
    ratingcats= {'Cars' 'Birds' 'Planes' 'Houses'};
    
    rnot1 = 'We are interested in your perception of your skill with different object categories.';
    rnot2 = 'Before beginning the experiment, please rate yourself on each category relative to the others,';
    rnot3 = 'considering your interest in, years exposure to, knowledge of, and familiarity with each category.';
    rnot4 = 'Please rate yourself on a scale from 1 - 9.';
    rnot5 = '             1 = zero expertise with the category';
    rnot6 = '             5 = mediocre expertise';
    rnot7 = '             9 = much expertise with the category';
    rnot8 = 'Please use the number keys at the TOP of the keyboard for your responses.';
    scale = '1      2       3       4       5       6       7       8       9';
    scaleN = 'NOVICE';
    scaleE = 'EXPERT';
    
    for rc=1:numel(ratingcats)
        ratingcat = ratingcats{rc};
        
        Screen('TextSize', w, 24);
        Screen('DrawText', w, rnot1, 100, 100, 255); Screen('DrawText', w, rnot2, 100, 150, 255);
        Screen('DrawText', w, rnot3, 100, 190, 255); Screen('DrawText', w, rnot4, 100, 280, 255);
        Screen('DrawText', w, rnot5, 100, 310, 255); Screen('DrawText', w, rnot6, 100, 340, 255);
        Screen('DrawText', w, rnot7, 100, 370, 255); Screen('DrawText', w, rnot8, 100, 420, 255);
        
        Screen('TextSize', w, 40); bounds = Screen('TextBounds', w, ratingcat);
        Screen(w, 'DrawText', ratingcat, cx-bounds(3)/2, cy+50, 255);
        Screen(w, 'DrawText', scale, cx-400, cy+150, 255);
        Screen(w, 'TextSize', 28);
        Screen(w, 'DrawText', scaleN, cx-480, cy+210, 255);
        Screen(w, 'DrawText', scaleE, cx+400, cy+210, 255);
        Screen('Flip', w); Waitsecs(.5);
        touch=0;
        while touch==0
            [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
            if  keyCode(key1)||keyCode(key2)||keyCode(key3)||keyCode(key4)||keyCode(key5)||keyCode(key6)||keyCode(key7)||keyCode(key8)||keyCode(key9);
                break;
            else 
                if touch; end;
                touch=0;
            end
        end
        if keyCode(key1); resp = 1;
        elseif keyCode(key2); resp = 2; elseif keyCode(key3); resp = 3;
        elseif keyCode(key4); resp = 4; elseif keyCode(key5); resp = 5;
        elseif keyCode(key6); resp = 6; elseif keyCode(key7); resp = 7;
        elseif keyCode(key8); resp = 8; elseif keyCode(key9); resp = 9;
        elseif touch==0; resp='0';
        end
        fprintf(VETfile, ('\n%s\t%d'),...
            ratingcat,resp);
        
        FlushEvents('keyDown');
        touch=0;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf(VETfile, ['\nsubjno\tsubjini\tcat\ttrial\ttarnb\texnb\ttarname' ...
        '\tdist1name\tdist2name\ttarloc\tresp\tfdbk\tac\trxt']);
    
    startexpt = GetSecs;
        
    fixation = uint8(ones(7)*255);
    fixation(4,:) = 0;
    fixation(:,4) = 0;
    
    [cat tarnb exnb tarname dist1name dist2name trlnb type tarloc]=...
        textread('DesignMatrix_Memory.txt','%s %u %u %s %s %s %u %u %u');
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Prepare & give instructions
    
    not0 = 'TASK INSTRUCTIONS:'; % not for test trials
    
    not1 = 'You will learn to recognize six exemplars from several different categories.';
    not2 = 'For example, you will learn six cars, six birds, and so on.';
    not3 = 'You begin with six targets from one category: a study phase, then a test phase.';
    not4 = 'NOTE: You will not always see the EXACT image studied,';
    not4b= 'but sometimes may see another example or view of the same exemplar/species.';
    not5 = '         Generalize your learning across different instances of the studied exemplar.';
    not6 = 'In each trial, you will see 3 images: ONE of the studied images + TWO false distractors.';
    not6b= 'There will always be a target present.';
    not7 = 'The target may occur in any position.';
    not8 = '         Press "1" if the target appears on the LEFT.';
    not9 = '         Press "2" if the target appears in the CENTER.';
    not10= '         Press "3" if the target appears on the RIGHT.';
    
    not11= 'You will study SIX targets at once.';
    not15= 'You will be given feedback for the first 12 trials only.';
    not16= 'You will no longer be given feedback.';
    not17= 'Take your time and be as ACCURATE as possible. Good Luck!';
    
    notP0 = 'Press the space bar to begin a few practice trials.';
    notP = 'PRACTICE: Memorize';
    notM = 'MEMORIZE:';
    notR = 'REVIEW:';
    notS = 'When ready, press the space bar to continue.';
    notQ = 'Which did you study?';
    notP1 = 'Practice trials are now over.';
    notP2 = 'Press the space bar to begin the actual experiment.';
    notB = 'Take a rest in between blocks if you need.';
    
    fbk1= 'Correct answer!';
    fbk2= 'Incorrect. Correct answer is ';
    fbk3= 'Incorrect.';
    
    notEnd = 'Thank you for your participation! Please get the experimenter';
    
    Screen(w, 'TextSize', 24);
    Screen('DrawText', w, not0, 100, 100, 255);
    Screen('DrawText', w, not1, 100, 150, 255);
    Screen('DrawText', w, not2, 100, 190, 255);
    Screen('DrawText', w, not3, 100, 230, 255);
    Screen('DrawText', w, not4, 100, 270, 255);
    Screen('DrawText', w, not4b, 100, 310, 255);
    Screen('DrawText', w, not5, 100, 350, 255);
    Screen('DrawText', w, not6, 100, 390, 255);
    Screen('DrawText', w, not6b, 100, 430, 255);
    Screen('DrawText', w, not7, 100, 470, 255);
    Screen('DrawText', w, notP0, 100, 580, 255);
    Screen('Flip', w);
    
    Waitsecs(.5);
    touch=0;  
    while touch==0
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        if keyCode(spaceBar); break; else touch=0; end
    end; while KbCheck; end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Practice-bart simpson cartoon.
    study=imread(strcat(imfolder, 'PracticeImages/practice_study.jpg'));
    test1=imread(strcat(imfolder, 'PracticeImages/practice_1.jpg'));
    test2=imread(strcat(imfolder, 'PracticeImages/practice_2.jpg'));
    test3=imread(strcat(imfolder, 'PracticeImages/practice_3.jpg'));
    
    Screen(w, 'TextSize', 40); bounds = Screen('TextBounds', w, notP);
    Screen(w, 'DrawText', notP, cx-bounds(3)/2, cy-380, 255);
    Screen(w, 'DrawText', notS, cx-380, cy+300, 255);
            
    Screen('PutImage', w, study);
    Screen('Flip', w); Waitsecs(.5);
    touch=0;		
    while ~touch
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        if keyCode(spaceBar); break; else touch=0; end
    end
    while KbCheck; end
    
    Screen('DrawText', w, not7, 100, 200, 255); Screen('DrawText', w, not8, 100, 260, 255);
    Screen('DrawText', w, not9, 100, 310, 255); Screen('DrawText', w, not10, 100, 360, 255);
    Screen('DrawText', w, notP0, 100, 420, 255);
    Screen('Flip', w); Waitsecs(.5);
    
    touch=0;		
    while ~touch
        [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
        if keyCode(spaceBar); break; else touch=0; end
    end
    while KbCheck; end
    
    for p=1:3
        
        Screen(w, 'TextSize', 40); bounds=Screen('TextBounds', w, '1');
        Screen(w, 'DrawText', '1', cx-200, cy-200, 255);
        Screen(w, 'DrawText', '2', cx-bounds(3)/2, cy-200, 255);
        Screen(w, 'DrawText', '3', cx+200, cy-190, 255);
        
        if p==1
            CurrPractice= test1;
        elseif p==2
            CurrPractice= test2;
        elseif p==3
            CurrPractice= test3;
        end
        
        Screen('PutImage', w, CurrPractice);
        Screen('Flip', w); Waitsecs(.5);
        
        tstart=GetSecs;
        touch=0;
        while touch==0 && GetSecs-tstart<respwindow
            [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
            if  keyCode(key1)||keyCode(key2)||keyCode(key3); break;
            else 
                if touch; end;
                touch=0;
            end
        end
        FlushEvents('keyDown');
        Screen('FillRect', w, bcolor);  
        Screen('Flip', w); Waitsecs(.5);
        
        if p==1
            if keyCode(key1); acc=1;
            else acc=0; end
        elseif p==2
            if keyCode(key2); acc=1;
            else acc=0; end
        elseif p==3
            if keyCode(key2); acc=1;
            else acc=0; end
        end
        
        if acc==1
            fdbkmsg= fbk1;
        else
            fdbkmsg= [fbk2 'BART.'];
        end
        
        Screen(w, 'TextSize', 40); bounds=Screen('TextBounds', w, fdbkmsg);
        Screen(w, 'DrawText', fdbkmsg, cx-bounds(3)/2, cy-300, 255);
        
        Screen(w, 'TextSize', 60); bounds=Screen('TextBounds', w, '****');
        if p==1 
            Screen(w, 'DrawText', '****', cx-250, cy+170, 255);
        elseif p==2 || p==3 
            Screen(w, 'DrawText', '****', cx-bounds(3)/2, cy+170, 255);
        end
        Screen('PutImage', w, CurrPractice);
        Screen('Flip', w); Waitsecs(.5);
                
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Present trials: 24 trls.
    
    for m = 150:numel(cat)
        
        imfoldercat = [imfolder  cat{m} '_memory/'];
        imfoldercatTAR = [imfolder  cat{m} '_memory/Targets/'];
        imfoldercatDIST = [imfolder  cat{m} '_memory/Distractors/'];
        
        study = find(type==1);
        studynameall = tarname(study);
        
        if m <= blklength
            studname = studynameall(1:studynb);
        elseif m > blklength && m <= 2*blklength
            studname = studynameall(studynb+1:2*studynb);
        elseif 2*m > blklength && m <= 3*blklength
            studname = studynameall(2*studynb+1:3*studynb);
        elseif 3*m > blklength && m <= 4*blklength
            studname = studynameall(3*studynb+1:4*studynb);
        end
        
        studyname=unique(studname);
        
        study1 = imread([imfoldercatTAR studyname{1}], 'jpg');
        study2 = imread([imfoldercatTAR studyname{2}], 'jpg');
        study3 = imread([imfoldercatTAR studyname{3}], 'jpg');
        study4 = imread([imfoldercatTAR studyname{4}], 'jpg');
        study5 = imread([imfoldercatTAR studyname{5}], 'jpg');
        study6 = imread([imfoldercatTAR studyname{6}], 'jpg');
        
        study1=imresize(study1,[200 200],'bicubic');
        study2=imresize(study2,[200 200],'bicubic');
        study3=imresize(study3,[200 200],'bicubic');
        study4=imresize(study4,[200 200],'bicubic');
        study5=imresize(study5,[200 200],'bicubic');
        study6=imresize(study6,[200 200],'bicubic');
        
        disptop = [study1 study2 study3];
        dispbot = [study4 study5 study6];
        studydisp = [disptop; dispbot];
        
        tar = imread([imfoldercatTAR tarname{m}], 'jpg');
        dist1 = imread([imfoldercatDIST dist1name{m}], 'jpg');
        dist2 = imread([imfoldercatDIST dist2name{m}], 'jpg');
        
        tar=imresize(tar,[200 200],'bicubic');
        dist1=imresize(dist1,[200 200],'bicubic');
        dist2=imresize(dist2,[200 200],'bicubic');
        
        if tarloc(m)==1
            triplet = [tar dist1 dist2];
        elseif tarloc(m)==2
            triplet = [dist1 tar dist2];
        elseif tarloc(m)==3
            triplet = [dist1 dist2 tar];
        end
        
        if mod(m,blklength)==1
            Screen(w, 'TextSize', 20);
            Screen('DrawText', w, not11, 100, 200, 255); Screen('DrawText', w, not15, 100, 410, 255); 
            Screen('DrawText', w, notS, 100, 460, 255);
            Screen('Flip', w); Waitsecs(.5);
            
            touch=0;  
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end; while KbCheck; end
            
        end
        
        if mod(m,blklength)==13
            Screen(w, 'TextSize', 20);
            Screen('DrawText', w, not16, 100, 200, 255); Screen('DrawText', w, not17, 100, 260, 255);
            Screen('DrawText', w, notS, 100, 400, 255);
            Screen('Flip', w); Waitsecs(.5);
            
            touch=0;  
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end; while KbCheck; end
            
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Beginning of a trial.
        trialstart = GetSecs;
        
        Screen('FillRect', w, bcolor); Screen('Flip', w); Waitsecs(.2);
        
        if mod(m,blklength)==1 || mod(m,blklength)==7 || mod(m,blklength)==13
            if mod(m,blklength)==1
                notnow= notM;
            elseif mod(m,blklength)==7 || mod(m,blklength)==13
                notnow= notR;
            end
            
            Screen(w, 'TextSize', 40); bounds = Screen('TextBounds', w, notnow);
            Screen(w, 'DrawText', notnow, cx-bounds(3)/2, cy-380, 255);
            Screen(w, 'DrawText', notS, cx-400, cy+330, 255);
            Screen('PutImage', w, studydisp);
                        
            Screen('Flip', w);
            touch=0;		
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end; while KbCheck; end
        end
        
        Screen(w, 'TextSize', 40); bounds=Screen('TextBounds', w, '1');
        Screen(w, 'DrawText', notQ, cx-180, cy-350, 255);
        Screen(w, 'DrawText', '1', cx-220, cy-180, 255);
        Screen(w, 'DrawText', '2', cx-bounds(3)/2, cy-180, 255);
        Screen(w, 'DrawText', '3', cx+200, cy-180, 255);
        
        Screen('PutImage', w, triplet); Screen('Flip', w);
        
        tstart=GetSecs;
        touch=0; noresponse=0;
        while touch==0
            [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
            rt(m)=(tpress-tstart)*1000;		
            if  keyCode(key1)||keyCode(key2)||keyCode(key3); break;
            else if touch; end; touch=0; end
            touch=0;
        end
        
        if ~noresponse  
            if keyCode(key1); resp = 1;
                if tarloc(m)==1; ac(m)=1;
                else ac(m)=0; end
            elseif keyCode(key2); resp = 2;
                if tarloc(m)==2; ac(m)=1;
                else ac(m)=0; end
            elseif keyCode(key3); resp = 3;
                if tarloc(m)==3; ac(m)=1;
                else ac(m)=0; end
            end     
        else  
            resp='nil'; ac(m)=-1; rt(m)=-1;
        end
        
        if mod(m,blklength)<13 && mod(m,blklength)>0
            if ac(m) == 1
                fdbkmsg= fbk1;
            else
                fdbkmsg= fbk3;
            end
            
            Screen(w, 'TextSize', 40); bounds=Screen('TextBounds', w, fdbkmsg);
            Screen(w, 'DrawText', fdbkmsg, cx-bounds(3)/2, cy-300, 255);
            
            Screen(w, 'TextSize', 60); bounds=Screen('TextBounds', w, '****');
            if tarloc(m)==1
                Screen(w, 'DrawText', '****', cx-250, cy+180, 255);
            elseif tarloc(m)==2
                Screen(w, 'DrawText', '****', cx-bounds(3)/2, cy+180, 255);
            elseif tarloc(m)==3
                Screen(w, 'DrawText', '****', cx+160, cy+180, 255);
            end
            Screen('PutImage', w, triplet);
            Screen('Flip', w); Waitsecs(.5);
            
                       
            fdbk = 1;
        else fdbk = 0;
        end
        
        
        if mod(m,blklength)==0;
            Screen(w, 'TextSize', 24);
            Screen('Drawtext', w, notB, 100, 100, 255);
            Screen('Drawtext', w, notS, 100, 160, 255);
            Screen('Flip', w);
            
            touch=0;		
            while ~touch
                [touch,tpress,keyCode]=PsychHID('KbCheck',usethiskeyboard);
                if keyCode(spaceBar); break; else touch=0; end
            end
            while KbCheck; end
        end
        
        
        fprintf(VETfile, ('\n%s\t%s\t%s\t%u\t%u\t%d\t%s\t%s\t%s\t%u\t%d\t%d\t%d\t%f'),...
            subjno,subjini,cat{m},m,tarnb(m),exnb(m),tarname{m},dist1name{m},dist2name{m},tarloc(m),resp,fdbk,ac(m),rt(m));
        
        FlushEvents('keyDown');
        touch=0;
        
    end    
    
    
    fclose('all');
    
    Screen('Drawtext', w, notEnd, 100, 100, 255);
    Screen('Flip', w);
    Waitsecs(.2);
    
    FlushEvents('keyDown');
    pressKey = KbWait;
    
    totalExptTime = (GetSecs - startexpt)/60;
    ACmean = mean(ac);
    RTmean = mean(rt);
    
    fprintf('\nExperiment time:\t%4f\t minutes',totalExptTime);
    fprintf('\nAverage accuracy:\t%4f',ACmean);
    fprintf('\nAverage response time:\t%4f\n',RTmean);
    
    ShowCursor;
    Screen('CloseAll');
    
catch
    
    ShowCursor;
    Screen('CloseAll');
    rethrow(lasterror);
end