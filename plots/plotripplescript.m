function plotripplescript()
% load some ripples and plot them and display some data
% add a pause function that continues after keyboard input so I
% can scroll between them.
% use the 'pause' command to make the plot wait for a key press before 
% plotting the next graph in the loop.


global etc ripples cellinfo;
etc.maxtet = 21;
etc.hbins = etc.maxtet+1;
%load('Eliripples01'); % load 'ripples'
%load('Elicellinfo'); % load 'cellinfo'
animal = animaldef('Dickinson', 'outputstruct', 1);
epochs = [1 2; 1 3; 2 2; 2 3; 3 2; 3 3];

%thisgetriptimes();
%[grout, ripplesdout]=thisgetripples();

getout = getriptimes(animal.dir, animal.pre, epochs, 1:etc.maxtet);
keyboard;
%%
function thisgetriptimes()
global etc;
for d = 1
	for e = 1:8
		animal = animaldef('Eliot', 'outputstruct', 1);
		getout = getriptimes(animal.dir, animal.pre, [d e], 1:etc.maxtet);
		if 0
			histout = histc(getout{d}{e}.nripples, 0:etc.hbins);
			pause;
			bar(histout);
			keyboard;
		end
	end
end


function [grout, ripplesdout]=thisgetripples()
%
%[grout, ripplesdout]=getripples([1 2], ripples, cellinfo);
%hist(ripplesdout)
%
global etc ripples cellinfo;

[grout, ripplesdout]=getripples([1 2], ripples, cellinfo);
%keyboard
%hist(ripplesdout)


