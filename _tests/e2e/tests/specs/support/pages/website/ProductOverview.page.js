import Page from '../Page';
import Driver from '../../utils/Driver.Extension';

class ProductOverview extends Page {
    get allDownloads() {return $('//h4[contains(.,"All Downloads")]');}
    get downloadBtn() {return $('//rhdp-os-download/div/a');}
    get downloadThankYou() {return $('#downloadthankyou');}

    open(productCode, tab) {
        super.open(`/products/${productCode}/${tab}`.toString());
        Driver.awaitIsDisplayed(this.allDownloads)
        Driver.screenShot('download-page.png')
        return this;
    }

    download() {
        Driver.click(this.downloadBtn);
        Driver.screenShot('where-are-we.png');
        return this;
    }

    awaitDownloadThankYou() {
        return Driver.awaitIsDisplayed(this.downloadThankYou);
    }
}

export default new ProductOverview;
