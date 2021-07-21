import 'package:flutter/material.dart';
import 'package:global_inv/src/pages/forms/add_product_form.dart';
import 'package:global_inv/src/pages/forms/delete_product_form.dart';

class DrawerLateralMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              title: Text('Jhon Doe',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              subtitle: Text('JhonDoeUser.name'),
            ),
            decoration: BoxDecoration(
              color: Colors.red,
            ),
          ),
          _manageProductOptions(),
          Divider(),
          ListTile(
            title: Text('Inventory status'),
            trailing: Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                    opacity: 0.7,
                    child: Text(
                      '4',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    )),
                IconButton(
                  icon: const Icon(Icons.priority_high),
                  onPressed: () => null,
                )
              ],
            )),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Statistics'),
            subtitle: Text('See global statistics of your sales and products'),
            trailing: Icon(Icons.bar_chart),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('Close the menu'),
            trailing: Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget _manageProductOptions() {
    return PopupMenuButton(
        child: ListTile(
          title: Text('Products'),
          subtitle: Text('Manage your products'),
          leading: Icon(Icons.inventory_2),
          trailing: Icon(Icons.more_vert),
        ),
        itemBuilder: (context) => [
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.plus_one),
                      title: Text('Add'),
                      subtitle: Text('Add a new product to your inventory'),
                      onTap: () {
                        Navigator.pushNamed(context, AddProductForm.routeName);
                      })),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.border_color),
                      title: Text('Edit'),
                      subtitle: Text('Modify an existing product'),
                      onTap: () {
                        Navigator.pushNamed(
                            context, DeleteProductform.routeName);
                      })),
              PopupMenuItem(
                  child: ListTile(
                      leading: Icon(Icons.delete),
                      title: Text('Delete'),
                      subtitle: Text('Delete a product from your inventory'),
                      onTap: () {
                        Navigator.pushNamed(
                            context, DeleteProductform.routeName);
                      }))
            ]);
  }
}
