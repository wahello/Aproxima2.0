import 'package:aproxima/Helpers/Helpers.dart';
import 'package:aproxima/Objetos/Comentario.dart';
import 'package:aproxima/Objetos/Protocolo.dart';
import 'package:aproxima/Telas/Comentario/ComentarioController.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ComentarioWidget extends StatefulWidget {
  Protocolo protocolo;

  ComentarioWidget(this.protocolo);

  _ComentarioWidgetState createState() => _ComentarioWidgetState();
}

class _ComentarioWidgetState extends State<ComentarioWidget> {
  ComentarioController cpc;
  final TextEditingController _commentController =
      new TextEditingController(text: 'LALALLA');
  DatabaseReference _comentarioRef;

  @override
  Widget build(BuildContext context) {
    cpc = BlocProvider.of<ComentarioController>(context);
    _comentarioRef = FirebaseDatabase.instance
        .reference()
        .child('Protocolos')
        .child(widget.protocolo.id.toString())
        .child('Comentarios');
    return Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            StreamBuilder<List<Comentario>>(
                stream: cpc.outComentarioPage,
                builder: ((context, snapshot) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    child: new ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return buildComentarioItem(snapshot.data[index]);
                        }),
                  );
                })),
            Positioned(
                bottom: 0,
                left: 0,
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(3),
                  child: new TextFormField(
                    controller: _commentController,
                  ),
                )),
          ],
        ));
  }

  Widget buildComentarioItem(Comentario c) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      new Padding(padding: EdgeInsets.only(right: 10)),
      CircleAvatar(
        radius: 20.0,
        backgroundImage: NetworkImage(
            'https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg-1024x683.jpg'),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Padding(padding: EdgeInsets.only(top: 4)),
                  Text(
                    c.criador.nome,
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 6)),
                  Text(
                    c.comentario,
                    style: TextStyle(fontSize: 14),
                  ),
                  new Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    Helpers().readTimestamp(c.created_at),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        fontStyle: FontStyle.italic),
                  ),
                  new Divider(),
                ],
              )))
    ]);
  }
}