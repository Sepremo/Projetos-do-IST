package prr.plans;
import java.io.Serializable;
import prr.communications.Communication;

public abstract class Plan implements Serializable {
    
    private double lessThan50chars;
    private double lessThan100chars;
    private double greaterThan100chars;
    private double voice;
    private double video;
    
/*
    public abstract double getPriceLessThan50chars(Communication communication );
    public abstract double getPriceLessThan100chars(Communication communication );
    public abstract double getPriceGreaterThan100chars(Communication communication );
    public abstract double getPriceVoice(Communication communication ); 
*/

    public Plan(double lessThan50chars, double lessThan100chars,
            double greaterThan100chars, double voice, double video){
                this.lessThan50chars = lessThan50chars;
                this.lessThan100chars = lessThan100chars;
                this.greaterThan100chars = greaterThan100chars;
                this.voice = voice;
                this.video = video;
    }

    public double getGreaterThan100chars(){
        return greaterThan100chars;
    }

    public double getLessThan50chars(){
        return lessThan50chars;
    }

    public double getLessThan100chars(){
        return lessThan100chars;
    }

    public double getVoice(){
        return voice;
    } 

    public double getVideo(){
        return video;
    } 

    
    public abstract double getTextPrice(Communication communication);
    
    public double getVoicePrice(Communication communication){
       return communication.getUnits()*voice;
       
    }
    public double getVideoPrice(Communication communication){
        return communication.getUnits()*video;
    }

}
