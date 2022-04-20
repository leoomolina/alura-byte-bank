import 'package:bytebank/components/byte_bank_app_bar.dart';
import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contato.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class InitContactsListState extends ContactsListState {
  const InitContactsListState();
}

@immutable
abstract class ContactsListState {
  const ContactsListState();
}

@immutable
class LoadingContactsListState extends ContactsListState {
  const LoadingContactsListState();
}

@immutable
class LoadedContactsListState extends ContactsListState {
  final List<Contato> _contatos;

  const LoadedContactsListState(this._contatos);
}

@immutable
class FatalErrorContactsListState extends ContactsListState {
  const FatalErrorContactsListState();
}

class ContactsListCubit extends Cubit<ContactsListState> {
  ContactsListCubit() : super(InitContactsListState());

  void reload(ContactDao dao) async {
    emit(LoadingContactsListState());
    dao.findAll().then((contatos) => emit(LoadedContactsListState(contatos)));
  }
}

class ContactsListContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    final ContactDao dao = ContactDao();

    return BlocProvider<ContactsListCubit>(
      create: (BuildContext context) {
        final cubit = ContactsListCubit();
        cubit.reload(dao);
        return cubit;
      },
      child: ContactsList(dao),
    );
  }
}

class ContactsList extends StatefulWidget {
  final ContactDao _dao;
  ContactsList(this._dao);

  @override
  State<StatefulWidget> createState() {
    return _ContactsListState();
  }
}

class _ContactsListState extends State<ContactsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ByteBankAppBar(
        context: context,
        title: 'Contatos',
      ),
      body: BlocBuilder<ContactsListCubit, ContactsListState>(
        builder: (context, state) {
          if (state is LoadingContactsListState ||
              state is InitContactsListState) return Progress("Carregando");

          if (state is LoadedContactsListState) {
            final contatos = state._contatos;
            return ListView.builder(
              itemBuilder: (context, index) {
                final contato = contatos[index];

                return _ContatoItem(
                  contato,
                  onClick: () {
                    push(context, TransactionFormContainer(contato));
                  },
                );
              },
              itemCount: contatos.length,
            );
          }
          return const Text("Erro desconhecido");
        },
      ),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ContactForm(),
        ));

        context.read<ContactsListCubit>().reload(widget._dao);
      },
      child: Icon(Icons.add),
    );
  }
}

class _ContatoItem extends StatefulWidget {
  final Contato contato;
  final Function onClick;

  _ContatoItem(
    this.contato, {
    required this.onClick,
  });

  @override
  State<_ContatoItem> createState() => _ContatoItemState();
}

class _ContatoItemState extends State<_ContatoItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          widget.contato.nome,
          style: TextStyle(fontSize: 24),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit),
          color: Colors.orange,
          iconSize: 32,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContactForm(contato: widget.contato)));
          },
        ),
        subtitle: Text(
          widget.contato.numeroConta.toString(),
          style: TextStyle(fontSize: 16),
        ),
        onTap: () => widget.onClick(),
      ),
    );
  }
}
