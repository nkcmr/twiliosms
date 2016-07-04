package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strings"
)

var (
	twilioSid    = flag.String("twilio-sid", "", "(required) twilio api account sid")
	twilioSecret = flag.String("twilio-secret", "", "(required) twilio api account secret")
	sender       = flag.String("sender", "", "(required) the phone number from which this message will be sent")
	recipient    = flag.String("recipient", "", "(required) the phone number of the recipient of this message")
	messageBody  = flag.String("body", "[empty]", "the message to send")
)

func getRequestBody() (*url.Values, error) {
	params := url.Values{}
	tvalmap := map[string]string{
		"recipient": "To",
		"sender":    "From",
		"body":      "Body",
	}
	vals := map[string]*string{
		"recipient": recipient,
		"sender":    sender,
		"body":      messageBody,
	}
	for key, param := range vals {
		if len(*param) == 0 {
			return nil, fmt.Errorf("'%s' parameter missing", key)
		}
		params.Set(tvalmap[key], *param)
	}
	return &params, nil
}

func main() {
	flag.Parse()
	params, err := getRequestBody()
	if err != nil {
		log.Fatal(err)
	}
	if len(*twilioSid) == 0 {
		log.Fatal("'twilio-sid' parameter missing")
	}
	if len(*twilioSecret) == 0 {
		log.Fatal("'twilio-secret' parameter missing")
	}
	client := &http.Client{}
	req, _ := http.NewRequest(
		"POST",
		fmt.Sprintf("https://api.twilio.com/2010-04-01/Accounts/%s/Messages.json", *twilioSid),
		strings.NewReader(params.Encode()),
	)
	req.SetBasicAuth(*twilioSid, *twilioSecret)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Content-Type", "application/x-www-form-urlencoded")
	resp, _ := client.Do(req)
	if resp.StatusCode >= 200 && resp.StatusCode < 300 {
		var data map[string]interface{}
		bodyBytes, _ := ioutil.ReadAll(resp.Body)
		err := json.Unmarshal(bodyBytes, &data)
		if err == nil {
			log.Println("message sent!")
			log.Println("id: ", data["sid"])
			log.Println("status:", data["status"])
		}
	} else {
		log.Println("failed to send sms!")
		log.Fatal(resp.Status)
	}
}
