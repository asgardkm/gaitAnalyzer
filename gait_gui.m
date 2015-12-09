function gait_gui(bool)
% SIMPLE_GUI2 Select a data set from the pop-up menu, then
% click one of the plot-type push buttons. Clicking the button
% plots the selected data in the axes.
 
   %  Create and then hide the GUI as it is being constructed.
   f = figure('Visible','off','Position',[360,500,650,400]);
 
   %  Construct the components.
   centermass = uicontrol('Style','pushbutton','String','centerMass',...
          'Position',[315,380,110,25],...
          'Callback',@centermassbutton_Callback);
   distknee2ank = uicontrol('Style','pushbutton','String','distKnee2Ank',...
          'Position',[315,340,110,25],...
          'Callback',@distknee2ankbutton_Callback);
   shankratio = uicontrol('Style','pushbutton',...
          'String','shankRatio',...
          'Position',[315,300,110,25],...
          'Callback',@shankratiobutton_Callback);
   grf = uicontrol('Style','pushbutton',...
          'String','getGRF',...
          'Position',[315,260,110,25],...
          'Callback',@grfbutton_Callback); 
   dblstance = uicontrol('Style','pushbutton',...
          'String','dblStance',...
          'Position',[315,220,110,25],...
          'Callback',@dblstancebutton_Callback); 
   stride = uicontrol('Style','pushbutton',...
          'String','findStride',...
          'Position',[315,180,110,25],...
          'Callback',@stridebutton_Callback);
   cadence = uicontrol('Style','pushbutton',...
          'String','cadence',...
          'Position',[315,140,110,25],...
          'Callback',@cadencebutton_Callback);
   gaitcycle = uicontrol('Style','pushbutton',...
          'String','getGaitcycle',...
          'Position',[315,100,110,25],...
          'Callback',@gaitcyclebutton_Callback);
   gcforce = uicontrol('Style','pushbutton',...
          'String','gcForce',...
          'Position',[315,60,110,25],...
          'Callback',@gcforcebutton_Callback);
      
      % set to gray out if the bool is false in bool
      if (bool.centermass_bool == 0)
          centermass.Enable = 'Inactive';
%           centermass.ButtonDownFcn = 'disp(''SACR or NAVE missing'')';
      end
      if (~bool.distknee2ank_bool)
          centermass.Enable = 'Inactive';
%           centermass.ButtownDownFcn = 'disp(''Knee or Ankle missing'')';
      end
      
      
   htext = uicontrol('Style','text','String','Select Data',...
          'Position',[325,90,60,15]);
      
   hpopup = uicontrol('Style','popupmenu',...
          'String',{'Peaks','Membrane','Sinc'},...
          'Position',[300,50,100,25],...
          'Callback',@popup_menu_Callback);
   ha = axes('Units','Pixels','Position',[50,60,200,185]); 
   align([centermass, distknee2ank, shankratio, grf, dblstance, stride, cadence, gaitcycle, gcforce,htext,hpopup],'Center','None');
   
   % Create the data to plot.
   peaks_data = peaks(35);
   membrane_data = membrane;
   [x,y] = meshgrid(-8:.5:8);
   r = sqrt(x.^2+y.^2) + eps;
   sinc_data = sin(r)./r;
   
   % Initialize the GUI.
   % Change units to normalized so components resize 
   % automatically.
   f.Units = 'normalized';
   ha.Units = 'normalized';
   centermass.Units = 'normalized';
   distknee2ank.Units = 'normalized';
   shankratio.Units = 'normalized';
   htext.Units = 'normalized';
   hpopup.Units = 'normalized';
   
   %Create a plot in the axes.
   current_data = peaks_data;
   surf(current_data);
   % Assign the GUI a name to appear in the window title.
   f.Name = 'Simple GUI';
   % Move the GUI to the center of the screen.
   movegui(f,'center')
   % Make the GUI visible.
   f.Visible = 'on';
 
   %  Callbacks for simple_gui. These callbacks automatically
   %  have access to component handles and initialized data 
   %  because they are nested at a lower level.
 
   %  Pop-up menu callback. Read the pop-up menu Value property
   %  to determine which item is currently displayed and make it
   %  the current data.
      function popup_menu_Callback(source,eventdata) 
         % Determine the selected data set.
         str = source.String;
         val = source.Value;
         % Set current data to the selected data set.
         switch str{val};
         case 'Peaks' % User selects Peaks.
            current_data = peaks_data;
         case 'Membrane' % User selects Membrane.
            current_data = membrane_data;
         case 'Sinc' % User selects Sinc.
            current_data = sinc_data;
         end
      end
  
   % Push button callbacks. Each callback plots current_data in
   % the specified plot type.
 
   function centermassbutton_Callback(source,eventdata) 
   % Display surf plot of the currently selected data.
      surf(current_data);
   end
 
   function distknee2ankbutton_Callback(source,eventdata) 
   % Display mesh plot of the currently selected data.
      mesh(current_data);
   end
 
   function shankratiobutton_Callback(source,eventdata) 
   % Display contour plot of the currently selected data.
      contour(current_data);
   end 
 
end 