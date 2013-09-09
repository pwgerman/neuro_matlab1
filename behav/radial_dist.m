% radial_dist

% 8 arm maze probability distributions

num_trials = 10000; % 100000 takes a couple minutes
max_arms = 100;

%sim = ceil(8*rand(num_sims, max_arms));
sim = randi(8, num_trials, max_arms);
for a = 1:4
    for t = 1: num_trials
        subsim(t,a) = min(find(sim(t,:)==a), [],2); % find first entry to arms 1 to 4, for each trial
    end
end
complete = max(subsim,[],2); % find entry number of the last of 4 correct arms entered for each trial
%hist(complete, 1:100)

sort_comp = sort(complete);
p05 = sort_comp(num_trials*.05);
p5 = sort_comp(num_trials*.5);
p1 = sort_comp(num_trials*.1);

% no working memory errors, but random selection of first arm entry
simp = perms(1:8);
for a = 1:4
    for t = 1: size(simp)
        subsimp(t,a) = min(find(simp(t,:)==a), [],2); % find first entry to arms 1 to 4, for each trial
    end
end
completep = max(subsimp,[],2); % find entry number of the last of 4 correct arms entered for each trial
%hist(complete, 1:100)
sort_compp = sort(completep);
sort_compp(size(completep,1)*.5)
mean(completep)  % = 7.2 or 3.2 errors for 8 arm maze.  See equation to derive in (Diamond, Fleshner, Ingersoll and Rose 1996)

% completep has value 5 till 2880 of 40320 permutations.  therefore, 5 or
% less has a probability of 2880/40320 = .0714
% completep has value 4 till 576 of 40320 permutations.  therefore, 5 or
% less has a probability of 576/40320 = .0143

%simp = randperm(8);
