package prr.plans;

import prr.communications.Communication;


public class PlanThree extends Plan {

    public PlanThree(){
        super(0,4,4,10,10);
    }

    @Override
    public double getTextPrice(Communication communication){
        int chars = communication.getUnits();
        if (chars < 50) return getLessThan50chars();
        if (50 <= chars && chars <100 ) return getLessThan100chars();
        if (chars>=100) return getGreaterThan100chars();
        return 0; //default value
    }

}
