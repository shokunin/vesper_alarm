// A simple Tweet POJO:
// $> javac AlertEvent.java
 
public class AlertEvent {
    private String user;
    private String text;
    private String timezone;
    private int retweets;
 
    public AlertEvent(String user, String text, String timezone, int retweets) {
        this.user = user;
        this.text = text;
        this.timezone = timezone;
        this.retweets = retweets;
    }
 
    public int getRetweets() {
        return retweets;
    }
 
    public String getText() {
      return text;
    }
 
    public String getUser() {
      return user;
    }
 
    public String getTimezone() {
      return timezone;
    }
 
    public String toString() {
      return user + ": " + text + " - (" + timezone + ")";
    }
}
