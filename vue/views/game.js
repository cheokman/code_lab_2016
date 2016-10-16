
var game = new Vue({
 el: '#game',
 data: {
   symbols: ["L1","L2","L3","H1","H2","H3","W","S"],
   screen_view:  [
     ["H1", "H2", "H1"],
     ["H1", "H2", "H2"],
     ["H1", "H2", "H2"]
                 ]
 },
  methods: {
    spin:function(){
      for (i=0; i<this.screen_view.length; i++) {
        reel = this.screen_view[i];
        for (j=0;j<this.screen_view[i].length;j++) {
          rnd = Math.floor(Math.random() * this.symbols.length);
          this.screen_view[i].splice(j,1,this.symbols[rnd]);
         
        }
      } 
       console.log(this.screen_view);
    }
   }
});