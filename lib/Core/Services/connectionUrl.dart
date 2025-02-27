 class Connectionurl{

//  static const connectionUrl = "https://192.168.18.199:5001/api";

// static const paymentApi = connectionUrl+"/Payment/payment";
// static const categoriesApi = connectionUrl+"/Categories";
// static const userLoginApi = connectionUrl+"/Auth/login";
// static const userRegisterApi = connectionUrl+"/Auth/register";
// static const orderApi = connectionUrl+"/Order";

// static const productAddApi = connectionUrl+"/Products/add";
// static const updateProductApi = connectionUrl+"/Products/update";

// static const productUploadImagesApi = connectionUrl+"/Products/uploadImages";
// static const updateProductImagesApi = connectionUrl+"/Products/updateImages=";
// static const fetchProductImagesApi = connectionUrl+"/Products/getProductImages?productId=";

// static const fetchAllProductsApi = connectionUrl+"/Products/getall";
// static const deleteProductImagesApi = connectionUrl+"/Products/deleteProductImage";
// static const fetchProductCategoryByIdApi = connectionUrl+"/Products/getlistbycategoryId?categoryId=";
// static const deleteProductApi = connectionUrl+"/Products/delete";

  static late String connectionUrl;
  static late String paymentApi;
  static late String categoriesApi;
  static late String userLoginApi;
  static late String userRegisterApi;
  static late String orderApi;
  static late String productAddApi;
  static late String updateProductApi;
  static late String productUploadImagesApi;
  static late String updateProductImagesApi;
  static late String fetchProductImagesApi;
  static late String fetchAllProductsApi;
  static late String deleteProductImagesApi;
  static late String fetchProductCategoryByIdApi;
  static late String deleteProductApi;
  static late String baseImgUrl;

  static void init({required String baseUrl}) {
    connectionUrl = baseUrl;
    paymentApi = "$connectionUrl/Payment/payment";
    categoriesApi = "$connectionUrl/Categories";
    userLoginApi = "$connectionUrl/Auth/login";
    userRegisterApi = "$connectionUrl/Auth/register";
    orderApi = "$connectionUrl/Order";
    productAddApi = "$connectionUrl/Products/add";
    updateProductApi = "$connectionUrl/Products/update";
    productUploadImagesApi = "$connectionUrl/Products/uploadImages";
    updateProductImagesApi = "$connectionUrl/Products/updateImages=";
    fetchProductImagesApi = "$connectionUrl/Products/getProductImages?productId=";
    fetchAllProductsApi = "$connectionUrl/Products/getall";
    deleteProductImagesApi = "$connectionUrl/Products/deleteProductImage";
    fetchProductCategoryByIdApi = "$connectionUrl/Products/getlistbycategoryId?categoryId=";
    deleteProductApi = "$connectionUrl/Products/delete";
    baseImgUrl = "http://16.16.65.136:5000/";
  }
}



