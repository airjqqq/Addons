import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Airj on 2016/12/29.
 */
public class Main {
    private static final String urlformater = "http://talkify.net/api/Speak?format=mp3&text=%s&refLang=-1&id=d3b36cc4-84c0-473b-a543-8b9e0bd30249&voice=&rate=4";

    public static void main(String[] args) throws IOException {
        Map<String, String> voice = new HashMap<>();
        voice.put("odynwind","旋风远离人群");
        voice.entrySet().stream().forEach(e->
        {
            String url = String.format(urlformater, e.getValue());
            try {
                saveUrl(e.getKey()+".mp3",url);
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        });
    }
    public static void saveUrl(final String filename, final String urlString)
            throws MalformedURLException, IOException {
        BufferedInputStream in = null;
        FileOutputStream fout = null;
        try {
            in = new BufferedInputStream(new URL(urlString).openStream());
            fout = new FileOutputStream(filename);

            final byte data[] = new byte[1024];
            int count;
            while ((count = in.read(data, 0, 1024)) != -1) {
                fout.write(data, 0, count);
            }
        } finally {
            if (in != null) {
                in.close();
            }
            if (fout != null) {
                fout.close();
            }
        }
    }
}
