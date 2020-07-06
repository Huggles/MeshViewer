/**
 * Created by jaapbranderhorst on 06/07/2020.
 */
const getRecordTypeName = (recordTypeId, objectInfo) => {
    let recordtypeInfos = objectInfo.data.recordTypeInfos;
    recordTypeId = Object.keys(recordtypeInfos).find(localRecordTypeId => localRecordTypeId === recordTypeId);
    return recordtypeInfos[recordTypeId].name;
}

export {getRecordTypeName}