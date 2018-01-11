const.tick = [0 0 4 10];
const.rectColor=[200 200 200];
const.selectRect = [0 0 10 40];
const.blue=[0 0 200];
const.slidebar_xsize=const.stimright/2;
const.slidebar_ysize=10;
const.baseBar =[0 0  const.slidebar_xsize  const.slidebar_ysize];

%Runtrials
const.awrect=CenterRect(const.baseBar, scr.rect);
Trialevents.awResp=zeros(1,length(Trialevents.trialmat));

% PAS response.
    %     Set Mouse to initial location.
    ShowCursor;
    SetMouse(const.awrect(1), const.awrect(2), scr.main);
    
    %     Define response range and rescale this to the 1-4 range.
    
    range=const.awrect(3)-const.awrect(1);
    rescaled=linspace(1,4,range);
    
    
    while 1
        %         Draw tickmarks
    vect=round(linspace(const.awrect(1),const.awrect(3),4));
    for tick=vect
        tick_offset = OffsetRect(const.tick, tick, const.awrect(2)-2);
        Screen('FillRect', scr.main, const.rectColor, tick_offset);
    end


    while 1
        %         Draw tickmarks
    vect=round(linspace(const.awrect(1),const.awrect(3),4));
    for tick=vect
        tick_offset = OffsetRect(const.tick, tick, const.awrect(2)-2);
        Screen('FillRect', scr.main, const.rectColor, tick_offset);
    end
    
    %     Draw PAS labels and numbers.
    %for txt=1:4
       % DrawFormattedText(scr.main, text.PASlabel{txt},vect(txt)-(0.3*(vect(2)-vect(1))), const.awrect(2)-150, WhiteIndex(scr.main),[],[]);
        %DrawFormattedText(scr.main, num2str(txt),vect(txt), const.awrect(2)+40, WhiteIndex(scr.main),[],[]);
    %end
    
    %    Draw the response bar
    Screen('FillRect', scr.main, const.rectColor, const.awrect);
    
    %     Get mouse position and determine whether or not it is in the bar.
    [mx, my, buttons] = GetMouse(scr.main);
    inside_bar = IsInRect(mx, my+1, const.awrect);
    resprect = CenterRectOnPointd(const.selectRect, mx, const.awrect(2)+1);
   
    %    Draw slider at new location
    Screen('FillRect', scr.main, const.blue, resprect);
    
    %    Mouse must be clicked, spacebar must be pressed and slider must be
    %    within response bar range.
   [KeyIsDown, endrt, KeyCode]=KbCheck;
   if KeyCode(my_key.space) && ismember(round(mx),const.awrect(1):const.awrect(3)) && sum(buttons) > 0
    Trialevents.awResp(i) = rescaled(round(mx)-const.awrect(1));
       break;
   end
   
   Screen('Flip', scr.main);
   
           if sum(buttons) <= 0
                offsetSet = 0;
           end
    end
    HideCursor;
