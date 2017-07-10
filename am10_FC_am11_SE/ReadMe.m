%%%%%%%%%%%%%%%%%%%%
% Clutter - Read Me%
%%%%%%%%%%%%%%%%%%%%
%
%   V1.0
%   29 / 05 / 2017
%
%   Implemented by :
%   Rosenholtz, R., Li, Y. and Nakano, L. & Thomas Langerak (only execute file)
%    & (hello@thomaslangerak.nl)
%
%   Supervisor :
%   Antti Oulasvirta
%
%   This work was funded by Technology Industries of Finland in a three - year
%   project grant on self - optimizing web services. The principal investigator
%   is Antti Oulasvirta of Aalto University (antti.oulasvirta@aalto.fi)
%
%%%%%%%%%
%License%
%%%%%%%%%
%
%
% Copyright (c) <year> <copyright holders>
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%
%
%%%%%%%%%
%Summary%
%%%%%%%%%
%
%     Rosenhotlz et al. explore different ways to computer different ways how cluttered an interface is. The two main
%     metrics proposed are Feature Congestion and Subband Entropy. Feature Congestion is calculating how difficult it is
%     to add an element that standsout from what is already present. In the paper they offer a clear and striking analogy
%
%     Subband Entropy says something about how organized an interface looks. The remaing elements returned in this function
%     are from previous work that was used by Rosenholtz et al. Subband Entropy is proven to be less of an indicator compared
%     to Feature Congestion
%
%     In this file nothing happens. Everything gets executed from the "execute" function.
%
%%%%%%%%%%%
%Technical%
%%%%%%%%%%%
%
%   Input : File path to image (has to be JPG)
%   Returns :   9 item list:
%               Feature Congestion Score(float)
%               Feature Congestion Map (int matrix)
%               Subband Entropy (float)
%               Colour Clutter Score (float)
%               Colour Clutter Map (int matrix)
%               Contrast Clutter Score (float)
%               Contrast  Clutter Map (int matrix)
%               Orientation Clutter Score (float)
%               Orientation Clutter Map (int matrix)
%
%%%%%%%%%%%%
%References%
%%%%%%%%%%%%
%
%   1.  Rosenholtz, R., Li, Y. and Nakano, L. Measuring visual clutter.
%       Journal of Vision 7, 2 (2007), 17.
%
%%%%%%%%%%%%%
% Change Log%
%%%%%%%%%%%%%
%
%%%%%%%%%%%%%%
% Bugs / Issues%
%%%%%%%%%%%%%%
%

%Everything below is made by the orginial author (Ruth Rosenholtz,
%Yuanzhen Li, and Lisa Nakano.) So are all the other files in this folder.
%With exception of the execute function.


% ReadMe.m
%
% Implements two measures of visual clutter (Feature Congestion and Subband
% Entropy) proposed in :
% Ruth Rosenholtz, Yuanzhen Li, and Lisa Nakano. "Measuring visual_clutter".
% Journal of Vision, 7(2), 2007. http : // www.journalofvision.com / 7 / 2 /
% Ruth Rosenholtz, Yuanzhen Li, and Lisa Nakano, May 2007.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Contents :
%
% getClutter_FC : computes Feature Congestion clutter, outputs both a scalar
%    (clutter of the whole image) and a map (local clutter).
% getClutter_SE : computes Subband Entropy clutter, outputs only a scalar.
% colorClutter : computes clutter maps indicating local variability in color
% contrastClutter : computes clutter maps indicating local variability in contrast
% orientationClutter : computes clutter maps indicating local variability in orientation
%
% (Please see individual routines for more info about parameters and outputs.)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Examples :
%
% get Feature Congestion clutter of a test map :
[clutter_scalar_fc, clutter_map_fc] = getClutter_FC('test.jpg');
% display the clutter map and output the scalar
% figure, imshow((clutter_map_fc - min(clutter_map_fc( : ))) / (max(clutter_map_fc( : ))-min(clutter_map_fc( : ))));
% title('Feature Congestion clutter map');
% clutter_scalar_fc
%
% get Subband Entropy clutter of the test map
clutter_se = getClutter_SE('test.jpg')
%
% compute and display color clutter map(s)
[clutter_levels, clutter_map] = colorClutter('test.jpg', 3);
% compute and display contrast clutter map(s)
[clutter_levels, clutter_map] = contrastClutter('test.jpg', 3, 1);
% compute and display orientation clutter map(s)
[clutter_levels, clutter_map] = orientationClutter('test.jpg', 3);