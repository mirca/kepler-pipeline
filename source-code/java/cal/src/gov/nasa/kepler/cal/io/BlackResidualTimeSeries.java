/*
 * Copyright 2017 United States Government as represented by the
 * Administrator of the National Aeronautics and Space Administration.
 * All Rights Reserved.
 * 
 * This file is available under the terms of the NASA Open Source Agreement
 * (NOSA). You should have received a copy of this agreement with the
 * Kepler source code; see the file NASA-OPEN-SOURCE-AGREEMENT.doc.
 * 
 * No Warranty: THE SUBJECT SOFTWARE IS PROVIDED "AS IS" WITHOUT ANY
 * WARRANTY OF ANY KIND, EITHER EXPRESSED, IMPLIED, OR STATUTORY,
 * INCLUDING, BUT NOT LIMITED TO, ANY WARRANTY THAT THE SUBJECT SOFTWARE
 * WILL CONFORM TO SPECIFICATIONS, ANY IMPLIED WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR FREEDOM FROM
 * INFRINGEMENT, ANY WARRANTY THAT THE SUBJECT SOFTWARE WILL BE ERROR
 * FREE, OR ANY WARRANTY THAT DOCUMENTATION, IF PROVIDED, WILL CONFORM
 * TO THE SUBJECT SOFTWARE. THIS AGREEMENT DOES NOT, IN ANY MANNER,
 * CONSTITUTE AN ENDORSEMENT BY GOVERNMENT AGENCY OR ANY PRIOR RECIPIENT
 * OF ANY RESULTS, RESULTING DESIGNS, HARDWARE, SOFTWARE PRODUCTS OR ANY
 * OTHER APPLICATIONS RESULTING FROM USE OF THE SUBJECT SOFTWARE.
 * FURTHER, GOVERNMENT AGENCY DISCLAIMS ALL WARRANTIES AND LIABILITIES
 * REGARDING THIRD-PARTY SOFTWARE, IF PRESENT IN THE ORIGINAL SOFTWARE,
 * AND DISTRIBUTES IT "AS IS."
 * 
 * Waiver and Indemnity: RECIPIENT AGREES TO WAIVE ANY AND ALL CLAIMS
 * AGAINST THE UNITED STATES GOVERNMENT, ITS CONTRACTORS AND
 * SUBCONTRACTORS, AS WELL AS ANY PRIOR RECIPIENT. IF RECIPIENT'S USE OF
 * THE SUBJECT SOFTWARE RESULTS IN ANY LIABILITIES, DEMANDS, DAMAGES,
 * EXPENSES OR LOSSES ARISING FROM SUCH USE, INCLUDING ANY DAMAGES FROM
 * PRODUCTS BASED ON, OR RESULTING FROM, RECIPIENT'S USE OF THE SUBJECT
 * SOFTWARE, RECIPIENT SHALL INDEMNIFY AND HOLD HARMLESS THE UNITED
 * STATES GOVERNMENT, ITS CONTRACTORS AND SUBCONTRACTORS, AS WELL AS ANY
 * PRIOR RECIPIENT, TO THE EXTENT PERMITTED BY LAW. RECIPIENT'S SOLE
 * REMEDY FOR ANY SUCH MATTER SHALL BE THE IMMEDIATE, UNILATERAL
 * TERMINATION OF THIS AGREEMENT.
 */

package gov.nasa.kepler.cal.io;

import java.util.ArrayList;
import java.util.List;

import gov.nasa.kepler.common.CollateralType;
import gov.nasa.kepler.common.Cadence.CadenceType;
import gov.nasa.kepler.fs.api.FloatTimeSeries;
import gov.nasa.kepler.fs.api.FsId;
import gov.nasa.kepler.fs.api.TimeSeries;
import gov.nasa.kepler.mc.fs.CalFsIdFactory;
import gov.nasa.kepler.mc.fs.CalFsIdFactory.PixelTimeSeriesType;
import gov.nasa.spiffy.common.persistable.Persistable;


/**
 * "Calibrated" Black time series data for a single row.
 * <p>
 * Objects of this class are immutable.
 * </p>
 * 
 * @author Sean McCauliff
 */
public class BlackResidualTimeSeries implements Persistable {
    /** The coadded columns represented by this CCD row. */
	private int row;
	/** The value of the residual at cadencesTimes.cadenceNumber[i].
	 * The length of this array is the same as the number of cadences in this
	 * unit of work.
	 */
	private float[] values;
	
	/** The uncertainty in the residual.  This has the same length as values.
	 */
	private float[] uncertainties;
	/** When gapIndicator[i] is true then values[i] and 
	 * uncertainties[i] are undefined.
	 */
	private boolean[] gapIndicators;

	/**
	 * Do not use. For serialization use only.
	 */
	public BlackResidualTimeSeries() {
	}

	/**
	 * Creates a {@link BlackTimeSeries} with the given values.
	 */
	public BlackResidualTimeSeries(int row, float[] leadingValues, 
			float[] uncertainties, boolean[] gapIndicators) {
		this.row = row;
		this.values = leadingValues;
		this.gapIndicators = gapIndicators;
		this.uncertainties = uncertainties;
	}

	public boolean[] getGapIndicators() {
		return gapIndicators;
	}

	public float[] getValues() {
		return values;
	}

	public int getRow() {
		return row;
	}

	public float[] getUncertainties() {
		return uncertainties;
	}

	public List<TimeSeries> toTimeSeries(int ccdModule, int ccdOutput, int startCadence, 
			int endCadence, CadenceType cadenceType,
			long taskId) {
		
		List<TimeSeries> rv = new ArrayList<TimeSeries>();
		
		FsId valuesId = 
			CalFsIdFactory.getCalibratedCollateralFsId(CollateralType.BLACK_LEVEL, 
					PixelTimeSeriesType.SOC_CAL, cadenceType, ccdModule,ccdOutput, getRow());
		FloatTimeSeries ts = 
			new FloatTimeSeries(valuesId, getValues(), 
					startCadence, endCadence,
					getGapIndicators(), taskId);
		
		rv.add(ts);
		
		FsId uncertId = 
			CalFsIdFactory.getCalibratedCollateralFsId(CollateralType.BLACK_LEVEL, 
					PixelTimeSeriesType.SOC_CAL_UNCERTAINTIES, cadenceType, ccdModule,ccdOutput, getRow());
		FloatTimeSeries uncertSeries = 
			new FloatTimeSeries(uncertId, getUncertainties(),
					startCadence, endCadence,
					getGapIndicators(), taskId);
		rv.add(uncertSeries);
		return rv;
	}
}