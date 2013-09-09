function ex_uicontrol
    % Example code for uicontrol reference page

    % Create a figure and an axes to contain a 3-D surface plot.
    figure
    hax = axes('Units','pixels');
    %surf(peaks)
    plot([1:4],[2:5]);
    
    
    
    % Create a uicontrol object to let users change the colormap
    % with a pop-up menu. Supply a function handle as the object's 
    % Callback:
    uicontrol('Style', 'popup',...
           'String', 'hsv|hot|cool|gray',...
           'Position', [20 340 100 50],...
           'Callback', @setmap);       % Popup function handle callback
                                       % Implemented as a subfunction
                                       
        % If you are executing a local callback function from within a 
        % MATLAB file, you must specify the callback as a function handle.                      
    
    % Add a different uicontrol. Create a push button that clears 
    % the current axes when pressed. Position the button inside
    % the axes at the lower left. All uicontrols have default units
    % of pixels. In this example, the axes does as well.
    uicontrol('Style', 'pushbutton', 'String', 'Clear',...
        'Position', [20 20 50 20],...
        'Callback', 'cla');        % Pushbutton string callback
                                   % that calls a MATLAB function

    % Add a slider uicontrol to control the vertical scaling of the
    % surface object. Position it under the Clear button.
    uicontrol('Style', 'slider',...
        'Min',1,'Max',50,'Value',41,...
        'Position', [400 20 120 20],...
        'Callback', {@surfzlim,hax});   % Slider function handle callback
                                        % Implemented as a subfunction
   
    % Add a text uicontrol to label the slider.
    uicontrol('Style','text',...
        'Position',[400 45 150 20],...
        'String','Vertical Exaggeration')
    
    f = uimenu('Label','Workspace', 'Position', 2);
    uimenu(f,'Label','New Figure','Callback','figure');
    uimenu(f,'Label','Save','Callback','save');
    uimenu(f,'Label','Quit','Callback','exit',... 
           'Separator','on','Accelerator','Q');
       
    g = uimenu(f,'Label','Workspace', 'Position', 2);
    uimenu(g,'Label','New Figure','Callback','figure');
    uimenu(g,'Label','Save','Callback','save');
    uimenu(g,'Label','New Plot','Callback','cla',... 
           'Separator','on','Accelerator','N');
       
    uicontrol('Style', 'pushbutton', 'String', 'New Plot',...
        'Position', [100 20 50 20],...
        'Callback', {@nuplot, hax});        % Pushbutton string callback
                                   % that calls a MATLAB function
end


function setmap(hObj,event) %#ok<INUSD>
    % Called when user activates popup menu 
    val = get(hObj,'Value');
    if val ==1
        colormap(jet)
    elseif val == 2
        colormap(hsv)
    elseif val == 3
        colormap(hot)
    elseif val == 4
        colormap(cool)
    elseif val == 5
        colormap(gray)
    end
end

function surfzlim(hObj,event,ax) %#ok<INUSL>
    % Called to set zlim of surface in figure axes
    % when user moves the slider control 
    val = 51 - get(hObj,'Value');
    zlim(ax,[-val val]);
end


function nuplot(hObj,event,hax) % plot new in old window
%val = 51 - get(hObj,'Value');
   % zlim(ax,[-val val]);    
    
%disp(ax);
%axes(hax);
x = [1:5];
%disp(x.^2);
plot(x,x.^2);
    
    %hnew=plot(ax,[0:5],[2:.1:2.5]);
end
    
    
