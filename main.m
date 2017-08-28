function [] = main()

switch getenv('ENV')
    case 'IUHPC'
        disp('loading paths for IUHPC')
        addpath(genpath('/N/u/hayashis/BigRed2/git/encode'))
        addpath(genpath('/N/u/hayashis/BigRed2/git/vistasoft'))
        addpath(genpath('/N/u/hayashis/BigRed2/git/jsonlab'))
        addpath(genpath('/N/u/hayashis/BigRed2/git/afq-master'))
    case 'VM'
        disp('loading paths for Jetstream VM')
        addpath(genpath('/usr/local/encode'))
        addpath(genpath('/usr/local/vistasoft'))
        addpath(genpath('/usr/local/jsonlab'))
        addpath(genpath('/usr/local/afq-master'))
end

% load my own config.json
config = loadjson('config.json');

% Load an FE strcuture created by the sca-service-life
load(config.fe);

% Extract the fascicles
fg = feGet(fe,'fibers acpc');


% Extract the fascicle weights from the fe structure
% Dependency "encode".
w = feGet(fe,'fiber weights');

% Eliminate the fascicles with non-zero entries
% Dependency "vistasoft"
fg = fgExtract(fg, w > 0, 'keep');


fg_sub = fg;
fg_sub.fibers = fg.fibers(1:10:end,:);

connectome.name = 'subsampled (x10) pos. weighted life output';
connectome.coords = fg_sub.fibers;
connectome.color = [0.2052473684,0.2466526316,0.6930631579];

mkdir('tracts')
savejson('', connectome, fullfile('tracts', 'connectome.json'));
end


