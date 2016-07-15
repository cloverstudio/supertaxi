package clover_studio.com.supertaxi.api;

import android.annotation.SuppressLint;
import android.os.AsyncTask;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.List;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import clover_studio.com.supertaxi.models.post_models.KeyValueModel;
import clover_studio.com.supertaxi.singletons.UserSingleton;
import clover_studio.com.supertaxi.utils.Const;

/**
 * Created by ubuntu_ivo on 12.08.15..
 */
public class UploadFileManagement {


    public class BackgroundUploader extends AsyncTask<Void, Integer, String>  {

        private String url;
        private String contentType;
        private File file;
        private OnUploadResponse listener;
        private List<KeyValueModel> params;

        public BackgroundUploader(String url, File file, String contentType, List<KeyValueModel> params, OnUploadResponse listener) {
            this.url = url;
            this.file = file;
            this.contentType = contentType;
            this.params = params;
            this.listener = listener;
        }

        @Override
        protected void onPreExecute() {
            listener.onStart();
        }

        @Override
        protected String doInBackground(Void... v) {

            String response = null;

            if(!file.exists()){
                return null;
            }

            if(url.startsWith("https")) {
                HttpsURLConnection.setFollowRedirects(false);
                HttpsURLConnection connection = null;
                String fileName = file.getName();
                try {
                    connection = (HttpsURLConnection) new URL(url).openConnection();
//                    connection.setHostnameVerifier(new HostnameVerifier() {
//                        @SuppressLint("BadHostnameVerifier")
//                        @Override
//                        public boolean verify(String hostname, SSLSession session) {
//                            return true;
//                        }
//                    });
//                    connection.setSSLSocketFactory(CustomOkHttpsClient.getSSLContext().getSocketFactory());
                    connection.setRequestMethod("POST");
                    String boundary = "---------------------------boundary";
                    String tail = "\r\n--" + boundary + "--\r\n";
                    connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
                    connection.setRequestProperty(Const.HeadersParams.ACCESS_TOKEN, UserSingleton.getInstance().getUser().token_new);
                    connection.setDoOutput(true);

                    String metadataPart = "--" + boundary + "\r\n"
                            + "Content-Disposition: form-data; name=\"metadata\"\r\n\r\n"
                            + "" + "\r\n";

                    StringBuilder metadataPart2 = new StringBuilder("");

                    if(params != null && params.size() > 0){
                        for(KeyValueModel item : params){
                            String part = "--" + boundary + "\r\n"
                                    + "Content-Disposition: form-data; name=\"" + item.key + "\"\r\n\r\n"
                                    + item.value + "\r\n";
                            metadataPart2.append(part);
                        }
                    }

                    String fileHeader1 = "--" + boundary + "\r\n"
                            + "Content-Disposition: form-data; name=\""+ Const.PostParams.FILE +"\"; filename=\""
                            + fileName + "\"\r\n"
                            + "Content-Type: " + contentType + "\r\n"
                            + "Content-Transfer-Encoding: binary\r\n";

                    long fileLength = file.length() + tail.length();
                    String fileHeader2 = "Content-length: " + fileLength + "\r\n";
                    String fileHeader = fileHeader1 + fileHeader2 + "\r\n";
                    String stringData = metadataPart + metadataPart2.toString() + fileHeader;

                    listener.onSetMax((int) fileLength);

                    long requestLength = stringData.length() + fileLength;
                    connection.setRequestProperty("Content-length", "" + requestLength);
                    connection.setFixedLengthStreamingMode((int) requestLength);
                    connection.connect();

                    DataOutputStream out = new DataOutputStream(connection.getOutputStream());
                    out.writeBytes(stringData);
                    out.flush();

                    int progress = 0;
                    int bytesRead;
                    byte buf[] = new byte[1024];
                    BufferedInputStream bufInput = new BufferedInputStream(new FileInputStream(file));
                    while ((bytesRead = bufInput.read(buf)) != -1) {
                        // write output
                        out.write(buf, 0, bytesRead);
                        out.flush();
                        progress += bytesRead;
                        // update progress bar
                        listener.onProgress(progress);
                    }

                    listener.onFinishUpload();

                    // Write closing boundary and close stream
                    out.writeBytes(tail);
                    out.flush();
                    out.close();

                    // Get server response
                    BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String line;
                    StringBuilder builder = new StringBuilder();
                    while((line = reader.readLine()) != null) {
                        builder.append(line);
                    }

                    response = builder.toString();

                } catch (Exception e) {
                    e.printStackTrace();
                    listener.onResponse(false, null);
                } finally {
                    if (connection != null) connection.disconnect();
                }
            }else{
                HttpURLConnection.setFollowRedirects(false);
                HttpURLConnection connection = null;
                String fileName = file.getName();
                try {
                    connection = (HttpURLConnection) new URL(url).openConnection();
                    connection.setRequestMethod("POST");
                    String boundary = "---------------------------boundary";
                    String tail = "\r\n--" + boundary + "--\r\n";
                    connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);
                    connection.setRequestProperty(Const.HeadersParams.ACCESS_TOKEN, UserSingleton.getInstance().getUser().token_new);
                    connection.setDoOutput(true);

                    String metadataPart = "--" + boundary + "\r\n"
                            + "Content-Disposition: form-data; name=\"metadata\"\r\n\r\n"
                            + "" + "\r\n";

                    StringBuilder metadataPart2 = new StringBuilder("");

                    if(params != null && params.size() > 0){
                        for(KeyValueModel item : params){
                            String part = "--" + boundary + "\r\n"
                                    + "Content-Disposition: form-data; name=\"" + item.key + "\"\r\n\r\n"
                                    + item.value + "\r\n";
                            metadataPart2.append(part);
                        }
                    }

                    String fileHeader1 = "--" + boundary + "\r\n"
                            + "Content-Disposition: form-data; name=\""+ Const.PostParams.FILE +"\"; filename=\""
                            + fileName + "\"\r\n"
                            + "Content-Type: " + contentType + "\r\n"
                            + "Content-Transfer-Encoding: binary\r\n";

                    long fileLength = file.length() + tail.length();
                    String fileHeader2 = "Content-length: " + fileLength + "\r\n";
                    String fileHeader = fileHeader1 + fileHeader2 + "\r\n";
                    String stringData = metadataPart + metadataPart2.toString() + fileHeader;

                    listener.onSetMax((int) fileLength);

                    long requestLength = stringData.length() + fileLength;
                    connection.setRequestProperty("Content-length", "" + requestLength);
                    connection.setFixedLengthStreamingMode((int) requestLength);
                    connection.connect();

                    DataOutputStream out = new DataOutputStream(connection.getOutputStream());
                    out.writeBytes(stringData);
                    out.flush();

                    int progress = 0;
                    int bytesRead;
                    byte buf[] = new byte[1024];
                    BufferedInputStream bufInput = new BufferedInputStream(new FileInputStream(file));
                    while ((bytesRead = bufInput.read(buf)) != -1) {
                        // write output
                        out.write(buf, 0, bytesRead);
                        out.flush();
                        progress += bytesRead;
                        // update progress bar
                        listener.onProgress(progress);
                    }

                    listener.onFinishUpload();

                    // Write closing boundary and close stream
                    out.writeBytes(tail);
                    out.flush();
                    out.close();

                    // Get server response
                    BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                    String line;
                    StringBuilder builder = new StringBuilder();
                    while((line = reader.readLine()) != null) {
                        builder.append(line);
                    }

                    response = builder.toString();

                } catch (Exception e) {
                    e.printStackTrace();
                    listener.onResponse(false, null);
                } finally {
                    if (connection != null) connection.disconnect();
                }
            }

            return response;
        }

        @Override
        protected void onPostExecute(String v) {
            if(v == null){
                listener.onResponse(false, null);
            }else{
                listener.onResponse(true, v);
            }
        }

    }

    private String getQuery(List<String[]> params) throws UnsupportedEncodingException
    {
        StringBuilder result = new StringBuilder();
        boolean first = true;

        for (String[] pair : params)
        {
            if (first)
                first = false;
            else
                result.append("&");

            result.append(URLEncoder.encode(pair[0], "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(pair[1], "UTF-8"));
        }

        return result.toString();
    }

    public interface OnUploadResponse{
        /**
         * start uploading
         */
        void onStart();

        /**
         * set size of file
         * @param max size of file
         */
        void onSetMax(int max);

        /**
         * current progress of uploading
         * @param current current
         */
        void onProgress(int current);

        /**
         * download file finished
         */
        void onFinishUpload();

        /**
         * communication with server finished
         * @param isSuccess is success
         * @param result path of saved file
         */
        void onResponse(boolean isSuccess, String result);
    }

}
