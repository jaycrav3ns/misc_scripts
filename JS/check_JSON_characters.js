//Check JSON for bad characters

function VerifyInput(input){
    for(var x=0; x<input.length; ++x){
        let c = input.charCodeAt(x);
        if(c >= 0 && c <= 31){
            throw 'problematic character found at position ' + x;
        }
    }
}
