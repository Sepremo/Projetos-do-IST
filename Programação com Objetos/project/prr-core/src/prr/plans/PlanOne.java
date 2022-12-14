package prr.plans;

import prr.communications.Communication;

public class PlanOne extends Plan {
 
    public PlanOne(){
        super(10,16,2,20,30);
    }

    @Override
    public double getTextPrice(Communication communication){
        int chars = communication.getUnits();
        if (chars < 50) return getLessThan50chars();
        if (50 <= chars && chars < 100 ) return getLessThan100chars();
        if(chars>= 100) return chars* getGreaterThan100chars();
        return 0; //default value
    }

    
}
