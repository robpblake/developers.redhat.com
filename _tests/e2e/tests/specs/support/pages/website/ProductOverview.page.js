import Page from '../Page';
import Driver from '../../utils/Driver.Extension';

class ProductOverview extends Page {
    get downloadBtn() {return $('//rhdp-os-download/div/a');}
    get downloadThankYou() {return $('#downloadthankyou');}

    open(productCode, tab) {
        super.open(`/products/${productCode}/${tab}`.toString());
        Driver.awaitIsDisplayed(this.downloadBtn)
        return this;
    }

    download() {
        Driver.click(this.downloadBtn);
        return this;
    }

    awaitDownloadThankYou() {
        return Driver.awaitIsDisplayed(this.downloadThankYou);
    }
}

export default new ProductOverview;
