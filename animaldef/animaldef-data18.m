function animalinfo = animaldef(animalname)

switch lower(animalname)
    % Walter's animals
    case 'a1'
        animalinfo = {'A1', '/data18/walter/stress/ab/a1/', 'a1'};
    case 'bukowski'
        animalinfo = {'Bukowski', '/data18/walter/stress/Buk/', 'Buk'};
    case 'cummings'
        animalinfo = {'Cummings', '/data18/walter/stress/Cum/', 'Cum'};
        %animalinfo = {'Cummings', '/data26/david/Cum/', 'Cum'};
    case 'dickinson'
        animalinfo = {'Dickinson', '/data18/walter/stress/Dic/', 'Dic'};
        %animalinfo = {'Dickinson', '/data26/david/Dic/', 'Dic'};
    case 'eliot'
        animalinfo = {'Eliot', '/data18/walter/stress/Eli/', 'Eli'};
    case 'jigsaw'
        animalinfo = {'Jigsaw', '/data18/walter/stress/Jig/', 'jig'};
    case 'p01'
        animalinfo = {'P01', '/data18/walter/stress/behavior/P01/', 'po1'};
    case 'p02'
        animalinfo = {'P02', '/data18/walter/stress/behavior/P02/', 'p02'};
    case 'q02'
        animalinfo = {'Q02', '/data18/walter/stress/behavior/Q02/', 'q02'};
    % R2, S2, S3, T3
    % Mattias' animals
    case 'frank'
        animalinfo = {'Frank', '/data/mkarlsso/Fra/', 'fra'};
    case 'miles'
        animalinfo = {'Miles', '/data/mkarlsso/Mil/', 'mil'};
    case 'nine'
        animalinfo = {'Nine', '/data/mkarlsso/Nin/', 'nin'};
    case 'ten'
        animalinfo = {'Ten', '/data/mkarlsso/Ten/', 'ten'};
    case 'dudley'
        animalinfo = {'Dudley', '/data/mkarlsso/Dud/', 'dud'};
    case 'alex'
        animalinfo = {'Alex', '/data/mkarlsso/Ale/', 'ale'};
    case 'conley'
        animalinfo = {'Conley', '/data/mkarlsso/Con/', 'con'};
    case 'bond'
        animalinfo = {'Bond', '/data/mkarlsso/Bon/', 'bon'};
    case 'five'
        animalinfo = {'Five', '/data13/mcarr/Fiv/', 'Fiv'};
    % Annabelle's animals
    case 'barack'
        animalinfo = {'Barack', '/data18a/asinger/Bar/', 'bar'};
    case 'calvin'
        animalinfo = {'Calvin', '/data18a/asinger/Cal/', 'cal'};
    case 'dwight'
        animalinfo = {'Dwight', '/data18a/asinger/Dwi/', 'dwi'};
    % Ana's animals
    case 'm01'
        animalinfo = {'m01', '/data/ana/M01/', 'm01'};
    case 'm02'
        animalinfo = {'m02', '/data/ana/M02/', 'm02'};
	% Maggies's animals
	case 'five'
        animalinfo = {'Five', '/data21/mcarr/Fiv/', 'Fiv'};
    case 'six'
        animalinfo = {'Six', '/data21/mcarr/Six/', 'Six'};
    case 'seven'
        animalinfo = {'Seven', '/data21/mcarr/Sev/', 'Sev'};
    case 'eight'
        animalinfo = {'Eight','/data21/mcarr/Eig/', 'Eig'};
    case 'fear'
        animalinfo = {'Fear', '/data21/mcarr/Fea/', 'Fea'};
    case 'ten'
        animalinfo = {'Ten', '/data21/mcarr/Ten/', 'ten'};
    case 'frank'
        animalinfo = {'Frank', '/data21/mcarr/Fra/', 'fra'};
    case 'bond'
        animalinfo = {'Bond', '/data21/mcarr/Bon/', 'bon'};
    case 'conley'
        animalinfo = {'Conley', '/data21/mcarr/Con/','con'};
    case 'dudley'
        animalinfo = {'Dudley', '/data21/mcarr/Dud/', 'dud'};
    case 'miles'
        animalinfo = {'Miles', '/data21/mcarr/Mil/', 'mil'};
    case 'corriander'
        animalinfo = {'Corriander','/data21/mcarr/Cor/','Cor'};
    case 'corrianderno'
        animalinfo = {'Corriander','/data21/monster/Cor/','Cor'};
    case 'cyclops'
        animalinfo = {'Cyclops','/data21/monster/Cyc/','Cyc'};
    case 'dunphy'
        animalinfo = {'Dunphy','/data21/monster/Dun/','Dun'};
    case 'fafnir'
        animalinfo = {'Fafnir','/data21/monster/Faf/','Faf'};
    case 'godzilla'
        animalinfo = {'Godzilla','/data21/monster/God/','God'};
    case 'grendel'
        animalinfo = {'Grendel','/data21/monster/Gre/','Gre'};
    case 'cml'
        animalinfo = {'Cml','/data21/monster/Cml/','Cml'};
    case 'nico'
        animalinfo = {'Nico','/data21/monster/Nic/','Nic'};        

    otherwise
        error(['Animal ',animalname, ' not defined.']);
end
