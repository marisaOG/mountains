%% Sample Time with Scope Blocks
% The Scope block and Time Scope block inherit and propagate sample time
% differently. This example helps you understand how sample time
% inheritance works when using a Scope block versus a Time Scope block.
% This example also shows what to do when you want to control the sample
% time propagation in the model.  
% 
% The Time Scope block is available with the DSP System Toolbox(TM).
%  
% Copyright 2021 The MathWorks, Inc.


%% Default Behavior with Inherited Sample Time
% This model shows two sine waves connected to a Time Scope block. The same
% sine waves are also connected to a Scope block. All blocks have the
% default inherited sample time (the *Sample Time* parameter equal to
% |-1|).
mdl = 'ScopeMultiRate';
open_system(mdl);

%%
% When you run this model, all blocks have continuous sample time.
% Continuous sample time occurs because the solver is set to variable step
% by default and all the blocks are set to inherited sample time. When you
% compile the model, Simulink(R) gives you four warnings that say, "
% |Source block specifies that its sample time (-1) is back-inherited. You
% should explicitly specify the sample time of sources.| " This warning
% helps avoid unwanted sample time propagation from an incorrectly
% configured model. To improve clarity, these warnings have been hidden in
% this example.
warning('off', 'Simulink:SampleTime:SourceInheritedTS');
warning('off','Simulink:SampleTime:InconsistentPortBasedTs');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate1.png>>
% 
%%
open_system([mdl '/Scope'])
open_system([mdl '/Time Scope'])
sim(mdl);
%% Default Behavior with Fixed-Step Solver and Inherited Sample Time
% Change the model to discrete sample time by setting the solver to fixed
% step.
set_param(mdl,'SolverType','Fixed-step');
set_param(mdl,'FixedStep','.01');

%%
% 
% <<../scope-sample-rate2.png>>
% 

%%
% The default plot type for the Scope block is |Auto|, which means that the
% plot changes type depending on the inputs. Blah blah blah
% discrete, the Scope block shows a stair plot. The default plot type of
% the Time Scope block is a |Line| plot, so the signal visualization does
% not change when the sample time changes to discrete.
delete(findall(0))
open_system([mdl '/Scope'])
open_system([mdl '/Time Scope'])
sim(mdl);

%% One Specified Sample Time on the Model
% Set the sample time of the first Sine Wave block to |0.03|. Specifying
% one sample time changes the sample time of the entire model, changing the
% sample time for the blocks connected to the Sine Wave block and the ones
% not connected to the block. Simulink changes the sample rates for all the
% blocks in the model because the lowest specified sample time takes
% precedence over a solver-determined sample time. The number of warnings
% drops to three. To improve clarity, these warnings have been hidden in
% this example.
delete(findall(0))
set_param([mdl '/Sine Wave'],'SampleTime','.03');
ScopeMultiRate([],[],[],'sizes')

%%
% 
% <<../scope-sample-rate3.png>>
% 
%% One Scope Input with Specified Sample Time
% Set the sample time of the Sine Wave2 block to |0.04|. Now the Sine Wave
% and Sine Wave2 blocks have specified sample times of |0.03| and |0.04|
% respectively. The scope blocks and Sine Wave input blocks with inherited
% sample time, they inherit the sample from the Sine Wave block with the
% specified sample time. Now each submodel within this model has a
% different sample time. All sample times are based on the sample times
% specified in the Sine Wave and Sine Wave2 blocks. The number of warnings
% drops to two. To improve clarity, these warnings have been hidden in this
% example.
set_param([mdl '/Sine Wave' ],'SampleTime','.03');
set_param([mdl '/Sine Wave2'],'SampleTime','.04');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate4.png>>
% 
%% All Inputs with Specified Sample Time
% Set the sample time of the Sine Wave1 block to |0.03|, and the sample
% time of the Sine Wave3 block to |0.04|. Now the Sine Wave and Sine Wave1
% blocks have a sample time of |0.03| and the Sine Wave2 and Sine Wave3
% blocks have a sample time of |0.04|. There are no warnings now because
% you have specified the sample times for all the source blocks. 
set_param([mdl '/Sine Wave' ],'SampleTime','.03');
set_param([mdl '/Sine Wave2'],'SampleTime','.04');
set_param([mdl '/Sine Wave1'],'SampleTime','.03');
set_param([mdl '/Sine Wave3'],'SampleTime','.04');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate4.png>>
% 

%% Inputs with Different Sample Times
% Set the sample time for the Sine Wave blocks so that the two inputs to
% each scope have a different sample time. Set the sample time in the Sine
% Wave and Sine Wave2 blocks to |0.03|, and the sample time for the Sine
% Wave1 and Sine Wave3 blocks to |0.04|. When you compile the model, you
% see that the Time Scope and Scope behave differently. The sample time for
% the Simulink Scope resolves to the fastest discrete rate (FDR). The FDR
% sample time is |0.01|, the greatest common denominator of the two input
% rates |0.03| and |0.04|. This smaller sample rate means that each signal
% is oversampled. By contrast, the sample time for the Time Scope resolves to
% multirate sample time, meaning each input is sampled at its own sample
% time.
%%
% In general, the DSP System Toolbox Time Scope uses port-based sample
% time, which processes the sample time for each input individually during
% initialization. Port-based sample time allows for multiple sample times
% and sample time offsets. The Simulink Scope uses block-based sample time,
% which resolves to a FDR sample time for the block as a whole during the
% initialization phase of the simulation.
%%
% During the simulation phase, the Scope block processes all inputs at the
% FDR sample rate. This sample rate can cause oversampling of some inputs.
% By contrast, during simulation, the Time Scope block processes a
% particular port only when a sample hit occurs for that port.

set_param([mdl '/Sine Wave' ],'SampleTime','.03');
set_param([mdl '/Sine Wave1'],'SampleTime','.04');
set_param([mdl '/Sine Wave2'],'SampleTime','.03');
set_param([mdl '/Sine Wave3'],'SampleTime','.04');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate5.png>>
% 
%% Set Sample Time on Scope Blocks
% Until now, the sample times for the scopes were inherited (|-1|). Set the
% sample time on both scopes to |0.01| the FDR in the previous section.
% Simulink issues two warnings, one per scope block, about "|Inconsistent
% sample times.|" There is a mismatch between the specified sample time in
% the scopes and their input ports. The warning lets you know the scope
% decides the sample hits and not the Simulink engine.
set_param([mdl '/Scope'],'SampleTime','.01');
set_param([mdl '/Time Scope'],'SampleTime','.01');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate6.png>>
% 
%% Inputs Inherit Sample Time from Scope
% Set the sample time for the Sine Wave1 and Sine Wave4 blocks to inherited
% (|-1|). The scope blocks backpropagate their sample time of |0.01| to
% these Sine Wave blocks. This change causes the two inherited sample time
% warning messages to appear again.
set_param([mdl '/Sine Wave1'],'SampleTime','-1');
set_param([mdl '/Sine Wave3'],'SampleTime','-1');
ScopeMultiRate([],[],[],'sizes')
%%
% 
% <<../scope-sample-rate7.png>>
% 
%%
bdclose all
%% Avoid Backpropagation from Scope with Rate Transition Blocks
% To avoid backpropagating sample time from the Scope to the blocks
% connected to it, either set the sample time on the connected blocks or
% use rate transition blocks. To specify the sample time on the connected
% blocks, set the sample time of Sine Wave1 and Sine Wave3 to |0.04| again.

%%
% To use rate transition blocks, insert a Rate Transition block before the
% Scope and Time Scope blocks. When you add the rate transition blocks, the
% two scopes behave identically. Each source with a specified sample time
% is connected to a Rate Transition block that resamples the signals at the
% output port according to its own rules. A Rate Transition block also
% prevents propagation of sample times from one input to another through
% the scope block.
%
% In this model, each input has a specified sample time and the scope
% blocks have inherited sample time.
mdl = 'ScopeMultiRate_RateTransition';
open_system(mdl);
sim(mdl);
