class Response{
  dynamic edited;
  dynamic total;
  int loopLvl = 0;
  String tab = '  ';
  String tabLvl = '';
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
      if(lvl == 1){
        tabLvl = '';
      }
      if(arrobj == true){          
      }else{
        tabLvl += '$tab';
      }
      thisarrlvl[lvl].forEach((key,value){
         if(lvl == 1){
           tabLvl = '';
         }
         if(value is String || value is int || value is bool){ 
          print('$tabLvl$key : $value');
         }else if(value is List){
           print('$tabLvl $key [');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj,key);
         }else{
           print('$tabLvl$key');
           thisarrlvl[lvl + 1] = value;
           replaceArr(thisarrlvl[lvl + 1],lvl + 1,arrobj);
         }
      });
    }else if(thisarrlvl[lvl] is List){
     dynamic inlist = '';
      for(int i = 0; i < thisarrlvl[lvl].length;i++){
         if(lvl == 1){
           tabLvl = '';
         }
         if(thisarrlvl[lvl][i] is Map){
           if(lvl > 1){
             if(i == 0){           
               tabLvl += '$tab';
             }
           }
         }else{
           if(i == 0){
             tabLvl += '$tab';
           } 
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
                    print('$tabLvl], // End ${thisendkey[lvl]}');
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
      if(lvl == 1){
        tabLvl = '';
      }
      print('$tabLvl${thisarrlvl[lvl]}');
    }
  }
}

