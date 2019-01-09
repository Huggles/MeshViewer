({
    outputProxy : function(record) {
        var obj = {};
        for(var propt in record) {
            obj[propt] = record[propt];
            if (typeof(record[propt]) == 'object') {
                obj[propt] = this.outputProxy(record[propt]);
            }
        }
        return obj;
  }
})