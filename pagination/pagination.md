<p align="center">
  <img src="https://github.com/user-attachments/assets/677ca74c-7c6e-4335-81d6-960614252cb0" width="500" alt="Pagination UI">
</p>

## Pagination and Page Size Options

Pagination enhances navigation in large datasets. Below are key features:

- **Page Size Selection**: Users can define how many items are displayed per page (e.g., 10, 20, 50).
- **Pagination Controls**:
  - **Next Page** and **Previous Page** buttons allow navigation.
  - Buttons are **disabled** when the first or last page is reached to prevent unnecessary interaction.

Example use case in Flutter:
```dart
  CustomPaginator(
                  initialPage: 1,
                  totalPages: totalPages,
                  pageSizeOptions: pageSizeOptions,
                  onPaginationChanged: _onPaginationChanged,
                ),
```
#Helper function for api call: 
```dart
void initState() {
    super.initState();
    totalPages = ref.read(productListProvider).when(
          initial: () => 1,
          loading: () => 1,
          success: (productList) =>
              (productList.totalItems / (widget.pageSize ?? 3)).ceil(),
          error: (_) => 1,
        );
    pageSizeOptions = ref.read(productListProvider).when(
          initial: () => [widget.pageSize ?? 3],
          loading: () => [widget.pageSize ?? 3],
          success: (productList) => productList.pageSizeOptions,
          error: (_) => [widget.pageSize ?? 3],
        );
    
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(productListProvider.notifier).getProductList(
            categoryId: widget.categoryId,
            pageSize: widget.pageSize,
            pageNumber: currentPage,
          ),
    );
  }

  void _onPaginationChanged(int pageNumber, int pageSize) {
    ref.read(currentPageProvider.notifier).setPage(pageNumber);
    ref.read(productListProvider.notifier).getProductList(
          categoryId: widget.categoryId,
          pageSize: pageSize,
          pageNumber: pageNumber,
        );
  }

