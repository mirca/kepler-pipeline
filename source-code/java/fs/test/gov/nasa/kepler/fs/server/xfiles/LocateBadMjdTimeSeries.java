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

package gov.nasa.kepler.fs.server.xfiles;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import gov.nasa.kepler.fs.api.FileStoreClient;
import gov.nasa.kepler.fs.api.FileStoreException;
import gov.nasa.kepler.fs.api.FsId;
import gov.nasa.kepler.fs.client.FileStoreClientFactory;
import gov.nasa.spiffy.common.collect.ListChunkIterator;

/**
 * Efficiently look through a bunch of MJD time series on the file store server
 * to find out which ones will give exceptions.
 * 
 * @author Sean McCauliff
 *
 */
public class LocateBadMjdTimeSeries {


    public static void main(String[] argv) throws Exception {
        FileStoreClient fsClient = FileStoreClientFactory.getInstance();
        Set<FsId> cosmicRayIds = fsClient.queryIds2("MjdTimeSeries@/pa/crs/lct/4/4/*");
        ListChunkIterator<FsId> chunkIt = new ListChunkIterator<FsId>(cosmicRayIds, 1024 * 10);
        List<FsId> allErrorIds = new LinkedList<FsId>();
        for (List<FsId> idChunk : chunkIt) {
            allErrorIds.addAll(findErrorIds(idChunk));
        }
        for (FsId errorId : allErrorIds) {
            System.out.println(errorId);
        }
    }

    private static List<FsId> findErrorIds(List<FsId> ids) {
        FileStoreClient fsClient = FileStoreClientFactory.getInstance();
        try {
            fsClient.readMjdTimeSeries(ids, 0, 60000.0);
        } catch (FileStoreException fse) {
            if (ids.size() == 1) {
                return ids;
            } else {
                int midPoint = ids.size();
                List<FsId> leftList = findErrorIds(ids.subList(0, midPoint));
                List<FsId> rightList = findErrorIds(ids.subList(midPoint, ids.size()));
                List<FsId> rv = new ArrayList<FsId>(leftList.size() + rightList.size());
                rv.addAll(leftList);
                rv.addAll(rightList);
                return rv;
            }
        }
        
        return Collections.emptyList();
        
    }
}
