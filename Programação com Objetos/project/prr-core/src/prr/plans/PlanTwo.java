package prr.plans;

import prr.communications.Communication;


public class PlanTwo extends Plan {

    public PlanTwo(){
        super(10,10,2,10,20);
    }
    
    @Override
    public double getTextPrice(Communication communication){
        int chars = communication.getUnits();
        if (chars < 50) return getLessThan50chars();
        if (50 <= chars && chars < 100 ) return getLessThan100chars();
        if(chars >= 100) return chars * getGreaterThan100chars();
        return 0; //default value
    }
}
