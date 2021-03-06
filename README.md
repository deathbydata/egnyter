
egnyter
=======

The `egnyter` package allows for seamless usage of Egnyte-based corporate filesharing systems from within an R environment.

For data scientists and analysts at companies that use Egnyte this will allow transfer of datasets and R objects without needing to create local copies or clones of the files. This has the pleasant side-effect of making code more reproducible since datasets can be referenced in their direct Egnyte location as opposed to a local user repository.

`egnyter` supports pipe-ing (through the `magrittr` pipe `%>%`) for interoperability with the [`tidyverse`](https://www.tidyverse.org/) suite of packages.

Why Egnyte?
-----------

For companies that use Egnyte fileshare it is often a primary repository for large data files and spreadsheets. Egnyte actually handles this task well and comes with automatic versioning and simple-to-use sharing and permissioning tools.

For analysts at these companies the problem comes when wanting to ingest these files into R for analysis - often resulting in files been cloned/downloaded into local folders which poses problems for reproducibility and code-sharing.

`egnyter` aims to solve this problem by allowing analysts to read and write files *directly* to the fileshare.

Installation
------------

You can install `egnyter` from Github using the following command:

``` r
# You must have devtools installed first
devtools::install_github("deathbydata/egnyter")
```

Setup
-----

### Registering an API key (do once)

Before you can use `egnyter` you are required to create a client API key. This process can be done easily on the [Egnyte for Developers](https://developers.egnyte.com/member/register) page.

When you register your application you should select "Internal Application (own company use only)" in the "Type" dropdown box.

This API key can be shared to analysts and data scientists who will be using `egnyter`.

### Creating a token (do for every user)

Once you have a token you will be able to authenticate yourself via `egnyter` to allow file transfers. To do this use the following code:

``` r
egnyter::set_token(username = "your egnyte username",
                   password = "your egnyte password",
                   client_id = "your internal application API key",
                   domain = "your custom egnyte domain") # Typically https://<yourcompanyname>.egnyte.com
```

N.B. If your Egnyte username or password changes, or if you want to use `egnyter` on another machine you will need to re-run `set_token` to refresh your authentication token.

Usage
-----

Primary usage of `egnyter` is through the `download_*` and `upload_*` functions.

When using each of these you are asked to provide a "path" argument which is the path to the file in your Egnyte fileshare. In **my** Egnyte fileshare system the value of this argument is given by starting with the **top-level folder** which is either "Shared" or "Private".

### Uploading

To upload a local data frame as a new file in Egnyte use `upload_csv` or `upload_feather` which make a call to `readr::write_csv` and `feather::write_feather` respectively, therefore arguments to these functions can be passed after the path.

``` r
my_car_data <- mtcars

my_car_data %>% upload_csv("/Shared/path/to/your/file.csv")
my_car_data %>% upload_feather("/Shared/path/to/your/file.feather")
```

If the filenames you specify already exist in Egnyte - **they will be overwritten**. However - depending on your settings - Egnyte will simply create a new version of this file automatically.

Note that, as long as we have run `set_token` (see above) we can omit the "token" and "domain" arguments as `egnyter` will pull them from your options.

To upload a remote file of any kind to a local file, you can use `upload_file`.

``` r
upload_file("/data/photos/file.jpg", "/Shared/path/to/your/new/file.jpg")
```

### Downloading

To download a remote file directly to a dataframe in R use `download_csv`, `download_excel` or `download_feather` which make a call to `readr::read_csv`, `readxl::read_excel` and `feather::read_feather` respectively, therefore arguments to these functions can be passed after the path.

``` r
my_feather_data <- download_feather("/Shared/path/to/your/file.feather")
my_csv_data <- download_csv("/Shared/path/to/your/file.csv", n_max = 2500)
my_excel_data <- download_excel("/Shared/path/to/your/file.xlsx", sheet = "datasheet")
```

Note that, as long as we have run `set_token` (see above) we can omit the "token" and "domain" arguments as `egnyter` will pull them from your options.

To download a remote file of any kind to a local file, you can use `download_file`.

``` r
download_file("/Shared/path/to/your/file.jpg", "/data/photos/file.jpg")
```

### Loading and Saving

In addition to transferring data stored in data frames to Egnyte, you may also want to transfer other objects (such as model objects). To support this kind of activity use the `upload_rds` and `download_rds` functions.

Note that these functions call the base `saveRDS` and `loadRDS` functions from the `base` library.

``` r
my_flower_model <- lm(Sepal.Length ~ ., data = iris)

# This saves an object into Egnyte
upload_rds(my_flower_model, dest = "/Shared/path/to/flower/data.rds")

# This will load an object called "my_flower_model" into the environment
my_flower_model <- download_rds("/Shared/path/to/flower/data.rds")
```

### Folders

You can create a new folder in your Egnyte filesystem by using the `create_folder` function.

``` r
create_folder("/Shared/path/to/folder", "newfolder")
```

Notes
-----

This R package has not been built in collaboration with Egnyte Inc. and I provide no guarantees about interoperability with your own Egnyte file-share.

When developing `egnyter` I only had access to **my company's** Egnyte system. Yours may have idiosyncracies that prevent the package working. Pull requests to address these are welcome!

In my experience `egnyter` can be slow to upload large data files.
