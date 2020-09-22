class Response{
  dynamic edited;
  dynamic total;
  String tab = ' ';
  String tablvl = '';
  
  Response({this.total});
  
  start(thisarr,lvl) async {
    print('please wait the process may take a long time...');
    await replaceArr(thisarr,lvl);      
  }
  
  replaceArr(thisarr,lvl){
    if(thisarr is Map){
      thisarr.forEach((key,value){
        if(lvl == 1){
          tablvl = '';
        }else{          
          tablvl += '$tab';
        }
      
         print('$tablvl $key (Map)');
         thisarr = value;
         replaceArr(thisarr,lvl + 1);
      });
    }else if(thisarr is List){
       if(lvl == 1){
         tablvl = '';
       }else{
          tablvl += '$tab';
       }
      
      
      for(int i = 0; i < thisarr.length;i++){
        if(thisarr[i] is String || thisarr[i] is int || thisarr[i] is bool)         {        
          print('$tablvl ${thisarr[i]} (List)');
        }else{
          thisarr = thisarr[i];
          replaceArr(thisarr,lvl + 1);
        }
      }
    }else{
      if(lvl == 1){
        tablvl = '';
      }else{
        tablvl += '$tab';
      }
      
      print('$tablvl $thisarr (Var)');
      
    }
  }
}