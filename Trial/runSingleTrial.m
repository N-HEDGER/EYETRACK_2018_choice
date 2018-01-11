function [const,Trialevents,eye,text,gaze]=runSingleTrial(scr,const,Trialevents,my_key,text,sounds,eye,i,gaze)
% ----------------------------------------------------------------------
% [Trialevents]=runSingleTrial(scr,const,Trialevents,my_key,text,i)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and collect inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% my_key : structure containing keyboard configurations
% Trialevents: structure containing trial events
% text: structure containing text config.
% sounds: structure containing sounds.
% eye: Eye-tracking info.
% i: the trial number
% ----------------------------------------------------------------------
% Output(s):
% Trialevents : struct containing all the variable design configurations
% with data appended.
% ----------------------------------------------------------------------
% Function created by Nick Hedger
% Project :     priming


% Trial-level variables;
trial.trialnum=num2str(Trialevents.trialmat(i,1));  
trial.stimtype=Trialevents.trialmat(i,2);
trial.scramtype=Trialevents.trialmat(i,3);
trial.duration=Trialevents.trialmat(i,4)/1000; 
trial.Model=Trialevents.trialmat(i,5);

% Print the condition details to the external file.

log_txt=sprintf(text.formatSpecTrial,trial.trialnum,text.stimlabel{trial.stimtype},text.scramlabel{trial.scramtype},num2str(trial.duration),num2str(trial.Model));
fprintf(const.log_text_fid,'%s\n',log_txt);

if const.debug
fprintf(strcat(log_txt,'\n'));
end

const.trialsdone=trial.trialnum;

%% Drawings
    HideCursor;
    % Fixation dot;
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.blue,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.blue,[],1);
    sound(sounds.begin,sounds.beginf);
    
    Fixonset=Screen('Flip',scr.main,[1]);
    
    % If there is an eyetracker detected, start recording gaze
    if isa(eye.eyetracker,'EyeTracker')
    gaze_data = eye.eyetracker.get_gaze_data();
    log_txt=sprintf(text.gazestart,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    end
    
    pause(const.fixdur);
    
    % Frames
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectl]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectr]); 
    
    if trial.stimtype==1 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==1 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectr]); 
    end
    
    
    
    Stimonset=Screen('Flip', scr.main);
    log_txt=sprintf(text.formatSpecFlip1,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    
    t1=GetSecs;
    [KeyIsDown,secs,keyCode]=KbCheck;
    while keyCode(my_key.left)==0 && keyCode(my_key.right)==0
        [KeyisDown,secs,keyCode]=KbCheck;
    end
    
    if keyCode(my_key.left)==1;
        Trialevents.resp{i}=1;
    elseif keyCode(my_key.right)==1;
        Trialevents.resp{i}=2;
    end
    t2=GetSecs;
    Trialevents.elapsed{i}=t2-t1;
    
    
    
    if isa(eye.eyetracker,'EyeTracker')
        collected_gaze_data=eye.eyetracker.get_gaze_data();
        eye.eyetracker.stop_gaze_data();
        log_txt=sprintf(text.gazestop,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        plottrial(const,scr,collected_gaze_data)
    else
        collected_gaze_data=i;
    end
    
    if Trialevents.resp{i}==1;
    Screen('DrawTexture',scr.main,const.tex.Selecttex,[],[const.framerectl]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectr]); 
    elseif Trialevents.resp{i}==2;
    Screen('DrawTexture',scr.main,const.tex.Selecttex,[],[const.framerectr]); 
    Screen('DrawTexture',scr.main,const.tex.Frametex,[],[const.framerectl]);
    end
    
    if trial.stimtype==1 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==1
    Screen('DrawTexture',scr.main,const.tex.stim{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stim{1,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==1 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectr]);
    elseif trial.stimtype==2 && trial.scramtype==2
    Screen('DrawTexture',scr.main,const.tex.stimsc{2,trial.Model},[],[const.stimrectl]);
    Screen('DrawTexture',scr.main,const.tex.stimsc{1,trial.Model},[],[const.stimrectr]); 
    end
    
    Selectoffset=Screen('Flip',scr.main,[]);
    WaitSecs(0.5)
    
    %  Offset
    
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.smallfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.smallerfixcol,[],1);
    Stimoffset=Screen('Flip',scr.main,[]);
    log_txt=sprintf(text.formatSpecFlip1,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    
    
    %  Update progress bar.
    progvec=round(linspace(1,const.stimright,length(Trialevents.trialmat)));
    progbar=[0 7 progvec(str2num(const.trialsdone)) 17];
    %  Draw slider at new location
    Screen('FillRect', scr.main, const.blue, progbar);
    
    t1=GetSecs;
    [KeyIsDown,secs,keyCode]=KbCheck;
    while keyCode(my_key.space)==0 && keyCode(my_key.escape)==0
        [KeyisDown,secs,keyCode]=KbCheck;
    end
    
    if keyCode(my_key.space)==1;
    close
    const.trialsdone=trial.trialnum;
    config.scr = scr; config.const = rmfield(const,'tex'); config.Trialevents = Trialevents; config.my_key = my_key;config.text = text;config.sounds = sounds;config.eye = eye;
    log_txt=sprintf(text.save,num2str(clock));
    fprintf(const.log_text_fid,'%s\n',log_txt);
    save(const.filename,'config');
    save(strcat(const.gazefilename,'_trial',num2str(i),'_gaze.mat'),'collected_gaze_data')
    
    Screen('DrawDots',scr.main,scr.mid,const.bigfixsize,const.bigfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallfixsize,const.smallfixcol,[],1);
    Screen('DrawDots',scr.main,scr.mid,const.smallerfixsize,const.smallerfixcol,[],1);
    
    Screen('Flip', scr.main);
    elseif keyCode(my_key.escape)==1
        const.trialsdone=trial.trialnum;
        config.scr = scr; config.const = rmfield(const,'tex'); config.Trialevents = Trialevents; config.my_key = my_key;config.text = text;config.sounds = sounds;config.eye = eye;
        log_txt=sprintf(text.formatSpecQuit,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        save(const.filename,'config');
        save(strcat(const.gazefilename,'_trial',num2str(i),'_gaze.mat'),'gaze')
        log_txt=sprintf(text.save,num2str(clock));
        fprintf(const.log_text_fid,'%s\n',log_txt);
        ShowCursor(1);
        Screen('CloseAll')
    end
    

    
end