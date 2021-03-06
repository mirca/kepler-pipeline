function [pixelFlux, Cuncertainties, rows, columns, inOptimalAperture, relevantIndices] = ...
    extract_target_pixels_and_uncertainties(pdqTempStruct, cadenceIndex, targetId, eePixelsOnlyFlag)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% function [pixelFlux, Cuncertainties, rows, columns, inOptimalApertureIndices, relevantIndices] = ...
%     extract_target_pixels_and_uncertainties(pdqTempStruct, cadenceIndex, targetId,eePixelsOnlyFlag)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Extracts the prows, columns, pixel values and the the covariance matrix
% of uncertainty for this target from pdqTempStruct which contains rows,
% columns, pixel fluxes for all targets on the modout.
%
% Inputs:
%
% Outputs:
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% Copyright 2017 United States Government as represented by the
% Administrator of the National Aeronautics and Space Administration.
% All Rights Reserved.
% 
% NASA acknowledges the SETI Institute's primary role in authoring and
% producing the Kepler Data Processing Pipeline under Cooperative
% Agreement Nos. NNA04CC63A, NNX07AD96A, NNX07AD98A, NNX11AI13A,
% NNX11AI14A, NNX13AD01A & NNX13AD16A.
% 
% This file is available under the terms of the NASA Open Source Agreement
% (NOSA). You should have received a copy of this agreement with the
% Kepler source code; see the file NASA-OPEN-SOURCE-AGREEMENT.doc.
% 
% No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY
% WARRANTY OF ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY,
% INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE
% WILL CONFORM TO SPECIFICATIONS, ANY IMPLIED WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR FREEDOM FROM
% INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE ERROR
% FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM
% TO THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER,
% CONSTITUTE AN ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT
% OF ANY RESULTS, RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY
% OTHER APPLICATIONS RESULTING FROM USE OF THE SUBJECT SOFTWARE.
% FURTHER, GOVERNMENT AGENCY DISCLAIMS ALL WARRANTIES AND LIABILITIES
% REGARDING THIRD-PARTY SOFTWARE, IF PRESENT IN THE ORIGINAL SOFTWARE,
% AND DISTRIBUTES IT "AS IS."
% 
% Waiver and Indemnity: RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS
% AGAINST THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND
% SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT. IF RECIPIENT'S USE OF
% THE SUBJECT SOFTWARE RESULTS IN ANY LIABILITIES, DEMANDS, DAMAGES,
% EXPENSES OR LOSSES ARISING FROM SUCH USE, INCLUDING ANY DAMAGES FROM
% PRODUCTS BASED ON, OR RESULTING FROM, RECIPIENT'S USE OF THE SUBJECT
% SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD HARMLESS THE UNITED
% STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY
% PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW. RECIPIENT'S SOLE
% REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE, UNILATERAL
% TERMINATION OF THIS AGREEMENT.
%

% Obtain necessary input data from pdqScienceClass data members
targetGapIndicators = pdqTempStruct.targetGapIndicators;

targetPixelRows     = pdqTempStruct.targetPixelRows;
targetPixelColumns  = pdqTempStruct.targetPixelColumns;

targetPixels        = pdqTempStruct.targetPixels(:, cadenceIndex);

numPixels           = pdqTempStruct.numPixels;


indexStart = 1;

if(~exist('eePixelsOnlyFlag', 'var'))
    eePixelsOnlyFlag = false;
end



% Extract only those pixels values, row values, and column values
% associated with the target
if (targetId == 1)
    indexStart  = 1;
    indexEnd    = numPixels(1);
end

if (targetId > 1)
    indexStart  = sum(numPixels(1:(targetId-1))) + 1;
    indexEnd    = sum(numPixels(1:(targetId)));
end

gapIndicators           = targetGapIndicators(indexStart:indexEnd,cadenceIndex);


isInOptimalAperture     = pdqTempStruct.isInOptimalAperture(indexStart:indexEnd);

validPixelsIndices   = find(~gapIndicators);

% if eePixelsOnly Flag is set, do not return inOptimalApertureIndices 
% as the logic is not coded for that option

[inOptimalApertureIndices, indexA]  = intersect(validPixelsIndices, find(isInOptimalAperture));

inOptimalAperture = false(length(validPixelsIndices),1);
inOptimalAperture(indexA) = true;

% uncertainties matrix contain entries only for those pixels that are
% present

if(eePixelsOnlyFlag)

    gapIndicatorsEe   = pdqTempStruct.eePixelExclusionIndicators(:, cadenceIndex);
    gapIndicatorsAll  = targetGapIndicators(:,cadenceIndex);
    gapIndicatorsCombined  = gapIndicatorsAll | gapIndicatorsEe;

else

    gapIndicatorsCombined  = targetGapIndicators(:,cadenceIndex);

end

validPixelsIndices  = find( ~gapIndicatorsCombined(indexStart:indexEnd));

validPixelsIndicesAll  = find(~targetGapIndicators(:,cadenceIndex));


if(~isempty(validPixelsIndices))


    indexToCover = (indexStart : indexEnd)';
    indexToCover = indexToCover(validPixelsIndices);

    [commonIndex, indexInAll] = intersect(validPixelsIndicesAll, indexToCover);


    Cuncertainties = pdqTempStruct.targetPixelsUncertaintyStruct(cadenceIndex).CtargetPixels(indexInAll, indexInAll);


    rows              = targetPixelRows(indexToCover);
    columns           = targetPixelColumns(indexToCover);
    pixelFlux         = targetPixels(indexToCover);



else

    pixelFlux = [];
    Cuncertainties = [];
    rows = [];
    columns = [];
    relevantIndices = [];

end


return




