package clover_studio.com.supertaxi.models.post_models;

/**
 * Created by ubuntu_ivo on 10.02.16..
 */
public class PostCallTaxiModel {
    public double latFrom;
    public double lonFrom;
    public String addressFrom;
    public double latTo;
    public double lonTo;
    public String addressTo;
    public int crewNum;

    public PostCallTaxiModel(double latFrom, double lonFrom, String addressFrom, double latTo, double lonTo, String addressTo, int crewNum){
        this.latFrom = latFrom;
        this.lonFrom = lonFrom;
        this.addressFrom = addressFrom;
        this.latTo = latTo;
        this.lonTo = lonTo;
        this.addressTo = addressTo;
        this.crewNum = crewNum;
    }

    @Override
    public String toString() {
        return "PostCallTaxiModel{" +
                "latFrom=" + latFrom +
                ", lonFrom=" + lonFrom +
                ", addressFrom='" + addressFrom + '\'' +
                ", latTo=" + latTo +
                ", lonTo=" + lonTo +
                ", addressTo='" + addressTo + '\'' +
                ", crewNum=" + crewNum +
                '}';
    }
}
