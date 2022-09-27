const puppeteer = require("puppeteer") ;

let name = "";
let email = "";
let pass = "";
let id = "";
let note = "Your message here." + "a";


function delay(time) {
  return new Promise(function(resolve) { 
      setTimeout(resolve, time)
  });
}

(async () => {
  const browser = await puppeteer.launch({ headless: false }) ;
  const page = await browser.newPage();
  await page.goto("https://www.linkedin.com/login");

  await page.evaluate((arg) => {
    return document.getElementById("username").value = arg;
  }, email);

  await page.evaluate((arg) => {
    return document.getElementById("password").value = arg;
  }, pass);

  await page.$eval(".btn__primary--large", elem => elem.click());

  await delay(2000);

  await page.goto("https://www.linkedin.com/in/"+id);

  await page.evaluate((arg) => {
    try {
      let str = "Invite " + arg.split(" ")[0];
      let dt = 0;
      const data = document.querySelectorAll('button');

      for (let i=0; i<data.length; i++) {
        let d = data[i].ariaLabel === null ? " " : data[i].ariaLabel.split(" ")[0] + " " + data[i].ariaLabel.split(" ")[1];
        console.log(d + " "+ str);
        if ((d === str) && (dt!=0)) {
          data[i].click();
          break;
        } else if (d === str) {
          dt = 1;
        }
      }
    } catch(err) {
      console.log("Error is "+err);
    }
  }, name);

  await page.evaluate(() => {
    const data = document.querySelectorAll('button')[1];
    data.click(); 
    return "";
  });

  await page.evaluate((arg) => {
    return document.getElementById("custom-message").value = arg;
  }, note);

  await page.keyboard.press("Backspace", {delay: 50});

  await delay(2000);

  await page.evaluate(() => {
    const data = document.querySelectorAll('button')[2];
    data.click(); 
    return "";
  });

  await browser.close();

})();