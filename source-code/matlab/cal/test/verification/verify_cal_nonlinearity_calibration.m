function verify_cal_nonlinearity_calibration(dataLocationStr)
%function verify_cal_nonlinearity_calibration(dataLocationStr)
%
% function to verify the CAL CSCI nonlinearity correction using ETEM2 data
%
%  ex: verify_cal_nonlinearity_calibration('/path/to/matlab/cal/')
%
%--------------------------------------------------------------------------
%
%  Requirement:      
%                    SOC1002        The SOC shall be capable of correcting
%                                   target, background, and collateral pixel data for
%                                   nonlinearity
%
%                    SOC1002.CAL.1  CAL shall be capable of correcting
%                                   target, background, and collateral
%                                   pixel data for nonlinearity
%
%  Test Data Sets:  
%                   ETEM2 runs with all motion and noise sources turned off, and 
%                       (1) 2Dblack, stars, smear, and dark on (non-requantized data)
%                       (2) 2Dblack, stars, smear, dark, and nonlinearity on  (non-requantized data)
%
%                                             
%  Test Data Sets ID:
%                   calInputs_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat
%                   calOutputs_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat
%                   calIntermedStructs_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat
%
%                   calInputs_calETEM_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_rq_cr.mat
%                   calOutputs_calETEM_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_rq_cr.mat
%                   calIntermedStructs_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_rq_cr.mat
%
%
%  Verification Method: Manual Inspection
%
%
%  Verification Process: 
%                   Run verify_cal_nonlinearity_calibration.m:
%
%                   (1) Load and plot the input and output (calibrated) collateral 
%                   pixels (masked and virtual smear) for runs with and without NL.
%                   The result is shown in figure 1.
%
%                   (2) Load and plot the input and output (calibrated) target 
%                   pixels for runs with and without NL. The result is shown in figure 2.
%
%
%
%       Output
%                   dataLocationStr/CAL_verification_figures/cal_nonlinearity_validation_I.fig
%                   dataLocationStr/CAL_verification_figures/cal_nonlinearity_validation_II.fig
%
%
%--------------------------------------------------------------------------
% 
%  Validate:        CAL nonlinearity model is consistent with the model
%                   injected by ETEM2
%
%  Test Data Sets:  
%                   ETEM2 data with all motion and noise sources turned off, 
%                   2Dblack, stars, smear, dark, and nonlinearity on,
%                   
%
%  Test Data Sets ID:
%                   ccdObject_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn.mat
%                   calInputs_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat
%
%--------------------------------------------------------------------------
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

cd(dataLocationStr);

% FC model parameters
nColsImaging    = 1100;
nLeadingBlack   = 12;

validCols = (nLeadingBlack+1:nLeadingBlack+nColsImaging)';


%--------------------------------------------------------------------------
% Test Ib: Compare input/output from nonlinearity-corrected pixels to data
% without nonlinearity (include smear and dark):
%
% calETEM_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_dir
% calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_dir
%--------------------------------------------------------------------------

%---------------------------------------
% read in inputs from CAL run with/without nonlinearity
load /path/to/matlab/cal/Long_Cadence_ETEM_For_CAL_Validation/calInputs_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat

targetInputPix_2D_ST_SM_DC_NL = [calPhotometricInputs.targetAndBkgPixels.values]';

mSmearInputPix_2D_ST_SM_DC_NL = [calCollateralInputs.maskedSmearPixels.values]';
vSmearInputPix_2D_ST_SM_DC_NL = [calCollateralInputs.maskedSmearPixels.values]';

% run CAL
calCollateralInputs = update_cal_inputs_with_new_parameters(calCollateralInputs);
calPhotometricInputs = update_cal_inputs_with_new_parameters(calPhotometricInputs);

calCollateralOutputs = cal_matlab_controller(calCollateralInputs);
calPhotometricOutputs = cal_matlab_controller(calPhotometricInputs);

calibratedTargetPix_2D_ST_SM_DC_NL         = [calPhotometricOutputs.targetAndBackgroundPixels.values]';  % nPixels x nCadences
calibratedMsmearPix_2D_ST_SM_DC_NL  = [calCollateralOutputs.calibratedCollateralPixels.maskedSmear.values]';    % nPixels x nCadences
calibratedVsmearPix_2D_ST_SM_DC_NL  = [calCollateralOutputs.calibratedCollateralPixels.virtualSmear.values]';   % nPixels x nCadences

%---------------------------------------

load /path/to/matlab/cal/Long_Cadence_ETEM_For_CAL_Validation/calInputs_calETEM_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_rq_cr.mat

targetInputPix_2D_ST_SM_DC    = [calPhotometricInputs.targetAndBkgPixels.values]';

mSmearInputPix_2D_ST_SM_DC    = [calCollateralInputs.maskedSmearPixels.values]';
vSmearInputPix_2D_ST_SM_DC    = [calCollateralInputs.maskedSmearPixels.values]';

% run CAL
calCollateralInputs = update_cal_inputs_with_new_parameters(calCollateralInputs);
calPhotometricInputs = update_cal_inputs_with_new_parameters(calPhotometricInputs);

calCollateralOutputs = cal_matlab_controller(calCollateralInputs);
calPhotometricOutputs = cal_matlab_controller(calPhotometricInputs);


calibratedTargetPix_2D_ST_SM_DC  = [calPhotometricOutputs.targetAndBackgroundPixels.values]';   % nPixels x nCadences
calibratedMsmearPix_2D_ST_SM_DC  = [calCollateralOutputs.calibratedCollateralPixels.maskedSmear.values]';    % nPixels x nCadences
calibratedVsmearPix_2D_ST_SM_DC  = [calCollateralOutputs.calibratedCollateralPixels.virtualSmear.values]';   % nPixels x nCadences

load calIntermedStructs_2D_ST_SM_DC_nl_lu_ff_rn_qn_sn_rq_cr.mat

%smearAndDarkCorrectedMsmear_2D_ST_SM_DC    = calCollateralIntermediateStruct.smearAndDarkCorrectedMsmear;  % = mSmearResidual - smearEstimate;
%smearAndDarkCorrectedVsmear_2D_ST_SM_DC    = calCollateralIntermediateStruct.smearAndDarkCorrectedVsmear;  % = vSmearResidual - smearEstimate;


%--------------------------------------------------------------------------
% Fig 1: plot the input and output (calibrated) collateral pixels for runs 
%        with and without NL
%--------------------------------------------------------------------------

figure;
subplot(2, 1, 1)

plot(mSmearInputPix_2D_ST_SM_DC, ...
    (mSmearInputPix_2D_ST_SM_DC_NL - mSmearInputPix_2D_ST_SM_DC), 'r.')

hold on
plot(vSmearInputPix_2D_ST_SM_DC, ...
    (vSmearInputPix_2D_ST_SM_DC_NL - vSmearInputPix_2D_ST_SM_DC), 'bo')


ylabel('Smear delta (NLon-NLoff)');
xlabel('Smear pixels');
title('CAL INPUT Msmear (red) and Vsmear (blue) differences NLon-NLoff  (2Dblack/stars/smear/dark on)');



subplot(2, 1, 2)

plot(calibratedMsmearPix_2D_ST_SM_DC(validCols, 1), ...
    (calibratedMsmearPix_2D_ST_SM_DC_NL(validCols, 1) - calibratedMsmearPix_2D_ST_SM_DC(validCols, 1)), 'r.')
%plot(smearAndDarkCorrectedMsmear_2D_ST_SM_DC(validCols, 1), ...
%    (smearAndDarkCorrectedMsmear_2D_ST_SM_DC_NL(validCols, 1) - smearAndDarkCorrectedMsmear_2D_ST_SM_DC(validCols, 1)), 'r.')


hold on
plot(calibratedVsmearPix_2D_ST_SM_DC(validCols, 1), ...
    (calibratedVsmearPix_2D_ST_SM_DC_NL(validCols, 1) - calibratedVsmearPix_2D_ST_SM_DC(validCols, 1)), 'bo')
%plot(smearAndDarkCorrectedVsmear_2D_ST_SM_DC(validCols, 1), ...
%    (smearAndDarkCorrectedVsmear_2D_ST_SM_DC_NL(validCols, 1) - smearAndDarkCorrectedVsmear_2D_ST_SM_DC(validCols, 1)), 'bo')


ylabel('Smear delta (NLon-NLoff)');
xlabel('Smear pixels');
title('CAL OUTPUT Msmear (red) and Vsmear (blue) differences NLon-NLoff (2Dblack/stars/smear/dark on)');


fileNameStr = [dataLocationStr 'CAL_verification_figures/cal_nonlinearity_validation_I'];
paperOrientationFlag = false;
includeTimeFlag      = false;
printJpgFlag         = false;

plot_to_file(fileNameStr, paperOrientationFlag, includeTimeFlag, printJpgFlag);


%--------------------------------------------------------------------------
% Fig 2: plot the input and output (calibrated) target pixels for runs 
%        with and without NL
%--------------------------------------------------------------------------
figure;
subplot(2, 1, 1)

plot(targetInputPix_2D_ST_SM_DC, ...
    (targetInputPix_2D_ST_SM_DC_NL ./ targetInputPix_2D_ST_SM_DC), 'c.')


ylabel('Target pix ratio (NLon/NLoff)');
xlabel('Target pixels');
title('CAL INPUT target pixel ratio of NLon/NLoff (2Dblack/stars/smear/dark on)');

subplot(2, 1, 2)

plot(calibratedTargetPix_2D_ST_SM_DC, ...
    (calibratedTargetPix_2D_ST_SM_DC_NL ./ calibratedTargetPix_2D_ST_SM_DC), 'c.')


ylabel('Target pix ratio (NLon/NLoff)');
xlabel('Target pixels');
title('CAL OUTPUT target pixel ratio of NLon/NLoff (2Dblack/stars/smear/dark on)');


fileNameStr = [dataLocationStr 'CAL_verification_figures/cal_nonlinearity_validation_II'];
paperOrientationFlag = false;
includeTimeFlag      = false;
printJpgFlag         = false;

plot_to_file(fileNameStr, paperOrientationFlag, includeTimeFlag, printJpgFlag);



%--------------------------------------------------------------------------
% Test Ib: Validate nonlinearity polynomial coeffs used in ETEM2 run and
% retrieved for CAL are consistent
%--------------------------------------------------------------------------

% load nonlinearity model that was injected into etem2 run
load ccdObject_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn.mat

etem2_nonlinCoeffts = dataUsedByEtemStruct.etem2_nonlinCoeffts;
% example =
%        1.0136
%   -0.00038067
%    1.1022e-06

% load nonlinearity model that was retrieved for and used by CAL
load calInputs_calETEM_2D_ST_SM_DC_NL_lu_ff_rn_qn_sn_rq_cr.mat

cal_nonlinCoeffs = calCollateralInputs.linearityModel.constants.array';
% example =
%     array: [1.0136 -0.00038067 1.1022e-06]

if ~isequal(etem2_nonlinCoeffts(:), cal_nonlinCoeffs(:))
    display('The NL poly coeffs used for CAL ARE NOT EQUAL to the etem2 injected nonlinearity coeffs.!')
else
    display('The NL poly coeffs used for CAL ARE CONSISTENT with the etem2 injected nonlinearity coeffs.')
end

cd(dataLocationStr);

return;

