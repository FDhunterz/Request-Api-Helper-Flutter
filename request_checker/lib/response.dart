class Response{
  dynamic edited;
  dynamic total;
  int loopLvl = 0;
  String tabLvl = ' ';
  String tab;
  Map<dynamic,dynamic> thisarrlvl = <dynamic,dynamic>{};
  Map<dynamic,dynamic> thisendkey = <dynamic,dynamic>{};
  
  Response({this.total});
  
  start(thisarr,lvl,arrayobject) async {
    print('please wait the process may take a long time...');
    await replaceArr(thisarr,lvl,arrayobject);      
  }
  
  replaceArr(thisarr,lvl,arrayobject,[endKey]){
   thisarrlvl[lvl] = thisarr;
   thisendkey[lvl] = endKey != null ? endKey : '';
   bool arrobj = arrayobject;
   
   if(thisarrlvl[lvl] is Map){
      tab = '';
      for(int i = 0; i < lvl - 1;i++){
        tab += tabLvl;
      }
      thisarrlvl[lvl].forEach((key,value){
         if(value is String || value is int || value is bool){ 
          print('$tab$key : $value');
         }else if(value is List){
           if(value.length > 0){
             print('$tab$key [');
           }else{
             print('$tab$key []');
           }
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj,key);
         }else if(value == null){
          print('$tab$key : null');
         }else{
           print('$tab$key');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
         }
      });
    }else if(thisarrlvl[lvl] is List){
      
     dynamic inlist = '';
      for(int i = 0; i < thisarrlvl[lvl].length;i++){
          tab = '';
          for(int i = 0; i < lvl - 1;i++){
            tab += tabLvl;
          }

         if(thisarrlvl[lvl][i] is String || thisarrlvl[lvl][i] is int || thisarrlvl[lvl][i] is bool)     
         {  
           inlist += '${thisarrlvl[lvl][i]}, ';
         }else{
            if(thisarrlvl[lvl][i] is Map || thisarrlvl[lvl][i] is List){
               if(i > 0){
                  print(' ');
               }
               arrobj = true;
            }else{
               arrobj = false;
            }
            thisarrlvl[lvl + 1] = thisarrlvl[lvl][i];
            replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
            if(thisarrlvl[lvl][i] is Map){
               if(i == thisarrlvl[lvl].length - 1){
                  if(lvl > 1){
                    print('$tab], /// End ${thisendkey[lvl]}');
                  }
               }
            }
         }
      } 
      if(inlist != ''){
        print('$tabLvl $inlist], // End ${thisendkey[lvl]}');
      }
      arrobj = false;
    }else{
      tab = '';
      for(int i = 0; i < lvl - 1;i++){
        tab += tabLvl;
      }
      print('$tab${thisarrlvl[lvl]}');
    }
  }
}