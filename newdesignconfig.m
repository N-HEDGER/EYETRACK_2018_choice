
rng(1)
vec=1:const.reps;
modvec=vec(randperm(length(vec)))';
sidevec=repmat([1;2],const.reps/2,1)
fullvecin=horzcat(sidevec,repmat(1,const.reps,1),repmat(const.durations(1),const.reps,1),modvec);
fullvecsc=horzcat(sidevec,repmat(2,const.reps,1),repmat(const.durations(1),const.reps,1),modvec);


fullvec=vertcat(fullvecin,fullvecsc);
     
Trialevents.trialmat=GenerateEventTable(fullvec,1,const.isfixed);

