import 'package:flutter_chat/chatData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/chatWidget.dart';

class Terminos extends StatefulWidget {
  static const String id = "welcome_screen";
  @override
  State<StatefulWidget> createState() {
    return _Terminos();
  }
}

class _Terminos extends State<Terminos> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ChatWidget.getAppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
               // color: const Color(0xffeeee00),
               // height: 300.0,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(left: 15, right: 15),
                child: const Text('''A. Los Términos

1. Aceptación de los Términos.
Bienvenido a www.escritoriolegal.com.mx  (“Servicio” o “Sitio”), cuya propiedad y funcionamiento pertenecen a Escritorio Ad Futurum S.A. de C.V. (“Escritorio Ad Futurum”). Estos términos y condiciones de uso se aplican a todos los visitantes y usuarios de la aplicación para dispositivos móviles y del sitio Escritorio Ad Futurum S.A. de C.V. (“Escritorio Ad Futurum”). Al hacer clic en “Acepto”, en la página de pago o de registro de la cuenta, o al utilizar el Sitio de cualquier modo, usted acepta cumplir y quedar obligado por este Acuerdo, así como los “Acuerdos Relacionados”, y todas las normas, políticas y exenciones de responsabilidad (incluidas las preguntas frecuentes para Clientes y Profesionales que se encuentran publicados en el Sitio o sobre los que se lo notifique (en conjunto, los “Términos”). Además, reconoce que se aplica nuestro Aviso de privacidad. Si no acepta la totalidad de los Términos, no utilice el Sitio. Revise todos los Términos cuidadosamente antes de utilizar el Sitio.

Al utilizar el Sitio, usted:
(i)	Acepta quedar obligado por los Términos 
(ii)	Declara que es mayor de 18 años de edad y puede celebrar contratos vinculantes en forma legal.

2. Definiciones.
El término indicado como “www.escritoriolegal.com.mx” y “sitio” hace referencia en todos los casos a la aplicación para dispositivos móviles (APP), al mismo sitio www.escritoriolegal.com.mx, y a Escritorio ad Futurum, S.A de C.V. en forma indistinta.
En los Términos, “Cliente”, “Clientes”, “Usuario”, “usted” y “su” hacen referencia al individuo o la entidad que crea una cuenta en www.escritoriolegal.com.mx y realiza una consulta en el Sitio.
En los Términos “www.escritoriolegal.com.mx”, “nosotros”, “nos” y “nuestro/a” hacen referencia a www.escritoriolegal.com.mx 
“Profesional” y/o “Profesionales” hace referencia a la persona que responde una pregunta en el Sitio.
“Acuerdos Relacionados” consiste en cualquier pacto (fáctico o tácito) en el que se establezca compromiso entre “Cliente” y “Profesionales”.
“Publicación” “Publicaciones”, “Publica”, “Publicado”, “Publicada” consiste manifestación escrita, verbal o virtual realizada por “Clientes”, “Profesionales” o “www.escritoriolegal.com.mx .” dentro del “Sitio”.
“Partes” al conjunto de “Cliente” y “www.escritoriolegal.com.mx .”
3. Comunicaciones electrónicas y derecho a modificar los Términos.
Al visitar www.escritoriolegal.com.mx  o enviarnos un correo electrónico, se está comunicando con nosotros por un medio electrónico. Usted nos autoriza a que le enviemos comunicaciones en forma electrónica. Nos comunicaremos con usted por correo electrónico o publicando avisos en este Sitio. Usted acepta que todos los acuerdos, avisos, divulgaciones y otras comunicaciones que le proporcionemos en forma electrónica cumplen con todos los requisitos legales de que estas comunicaciones sean por escrito. Usted se compromete a proporcionarnos, y mantener en su perfil de cuenta www.escritoriolegal.com.mx , su dirección de correo electrónico actual y activa.

www.escritoriolegal.com.mx  puede cambiar, revisar o modificar cualquiera de los Términos en cualquier momento mediante la publicación en el Sitio. Los cambios entrarán en vigor automáticamente al momento de su publicación. Su uso continuo del Servicio implicará su aceptación de las modificaciones. Si no acepta las modificaciones, su único y exclusivo recurso será interrumpir el uso del Sitio. Los últimos Términos se publicarán en el Sitio, y usted siempre deberá revisarlos antes de usar el Sitio.

B. El sitio web
4. El Sitio de www.escritoriolegal.com.mx  es un servicio. Contenido de terceros.
El Sitio de www.escritoriolegal.com.mx  es un servicio con fines informativos, educativos y de orientación en temas jurídicos legales, que permite que los Clientes realicen preguntas y que los Profesionales respondan. Son los Usuarios del Sitio, no www.escritoriolegal.com.mx , quienes proporcionan el contenido de las Publicaciones. Los Profesionales determinan qué preguntas responder. Los Profesionales no necesariamente son empleados ni agentes de www.escritoriolegal.com.mx , sino que, al igual que los Clientes, son Usuarios del Sitio.

www.escritoriolegal.com.mx  no participa en la conversación entre Clientes y Profesionales, no vincula a los Clientes con Profesionales específicos y no avala ni recomienda a Profesionales específicos. Usted reconoce que www.escritoriolegal.com.mx  no edita, modifica, filtra, examina, supervisa, avala ni garantiza el contenido de las Publicaciones, ni puede hacerlo. En consecuencia, www.escritoriolegal.com.mx  no es responsable de ningún acto u omisión de los Profesionales, del contenido de las Publicaciones, de la capacidad de los Profesionales para responder las preguntas o de la capacidad de los Clientes para interpretar las respuestas. Sin perjuicio de lo anterior, www.escritoriolegal.com.mx  se reserva el derecho, sin estar obligado, de negarse a publicar o de eliminar cualquier contenido.

Las PREGUNTAS POR EMERGENCIAS Y SITUACIONES DE CRISIS (en particular, relacionadas con situaciones legales catalogadas como graves de acuerdo a las leyes mexicanas vigentes para el estado de Nuevo León) deben hacerse de inmediato por teléfono o personalmente a Profesionales idóneos (por ejemplo, llamar al 911). El Sitio no es un servicio apropiado para tratar estas situaciones.

5. Las Publicaciones podrán ser privadas y/o confidenciales. Anonimato.
El Sitio es un foro basado en Internet y la información suministrada en el contenido de sus preguntas, respuestas, solicitudes de información, contestaciones, perfiles, firmas, calificaciones, comentarios y publicaciones en el Foro de Profesionales y en otros lugares donde los Usuarios se comunican en el Sitio (en conjunto, “Publicaciones”) serán privadas y confidenciales, por lo que respecta a la obligación del Profesional de mantener el secreto entre Profesional y Cliente, siendo el Profesional siempre el responsable sobre el privilegio de confidencialidad y en este acto el Usuario exime de toda responsabilidad al respecto a  www.escritoriolegal.com.mx , así mismo el usuario acepta los riesgos de vulneración de la información tales como lectura, recopilación y utilización. Por ejemplo: búsquedas realizadas por motores indexadores de preguntas, respuestas y otro tipo de Publicaciones para permitir que aparezcan en resultados de motores de búsqueda, igualmente ataques a la información interna de las bases de datos propiedad de www.escritoriolegal.com.mx

6. Verificación. No se debe confiar en el término “Profesionales”
Cada Profesional del Sitio tiene, como mínimo, una credencial que ha sido verificada por un servicio de verificación y que es pertinente a la categoría en la que ofrece respuestas, a menos que el Profesional responda preguntas de una nueva categoría que todavía está en evaluación por parte de www.escritoriolegal.com.mx  en su Sitio. Si desea conocer los detalles acerca de las credenciales verificadas para cada Profesional, entre al perfil del Profesional. La información sobre los Profesionales que no se muestra como verificada es aquélla que el Profesional ha suministrado pero que no se ha verificado. El uso del término “Profesionales” por parte de www.escritoriolegal.com.mx  o en el Sitio sólo describe a los Usuarios que responden preguntas en el Sitio y no garantiza ningún nivel específico de conocimiento de estos Profesionales.
www.escritoriolegal.com.mx  usará información para la realización de las verificaciones descritas anteriormente; www.escritoriolegal.com.mx  no otorga por su cuenta las credenciales de los Profesionales. 
No obstante, el “Usuario” es consciente de los riesgos existentes, y las Partes reconocen y acuerdan que “www.escritoriolegal.com.mx ” no garantiza el contenido ni la calidad de la información Publicada y no es responsable en forma alguna en caso de daños y/o Perjuicios al “Usuario” y “Profesionales“, sin embargo se compromete a brindar servicios con los más altos estándares de honestidad y rectitud, brindando el apoyo necesario para aclarar cualquier mal entendido o mala interpretación de las instrucciones proporcionadas por los Profesionales en el sitio y podrá vigilar y recopilar las interacciones e información entre el Profesional y el Usuario.
Ante cualquier incumplimiento de los estándares de calidad, términos y condiciones ofrecidos, EscritorioAdFuturumse reserva la rescisión de contratos o acuerdos entre las partes.
De igual forma, el acuerdo entre las partes dentro del presente contrato estará protegido bajo los términos y privilegios del secreto profesional, por lo que en atención al artículo 2590 del Código Civil Federal vigente y el artículo 36 de la Ley Reglamentaria del Artículo 5o. Constitucional, www.escritoriolegal.com.mx se compromete a dentro de sus posibilidades proteger y hacer proteger la información proporcionada por el “Usuario”.
7. No se brinda asesoramiento, sino información. No se crea una relación entre Clientes y Profesionales.
Las respuestas de este Sitio se deben utilizar solamente con fines informativos generales, no como sustituto de la evaluación personal o el asesoramiento profesional específico (del área psicológica, legal, impositiva, financiera, etc.). Las leyes, reglas, estándares, prácticas, procedimientos y otras autoridades normativas que rigen su pregunta específica pueden cambiar según su ubicación y/o temporalidad, así como, la información que habitualmente se percibe mediante evaluaciones o visitas personales. Los Profesionales quizá estén matriculados o autorizados, hayan estudiado o tengan empleo o experiencia solamente en determinadas diciplinas jurídicas. Inclusive cada Profesional podrá tomar una interpretación jurídica distinta para el mismo caso concreto ya que el derecho no es una ciencia exacta y está sujeta a interpretación.
En el Sitio, no se crearán relaciones entre Profesionales y Clientes.
www.escritoriolegal.com.mx   se compromete a salvaguardar las comunicaciones en este Sitio de acuerdo a sus estándares y políticas internas, así mismo es oportuno destacar que estas son confidenciales, sin embargo EscritorioAdFuturum no se responsabilizará por el uso dado por el Profesional y/o vulneraciones de la seguridad informática. Las comunicaciones en este Sitio son limitadas y no incluyen medidas de seguridad ni procedimientos que son habituales en las evaluaciones y consultas personales. Así mismo, si el Cliente así lo decide, este podrá contratar los servicios profesionales de www.escritoriolegal.com.mx mediante contrato de prestación de servicios profesionales, mismo que será elevado a su categoría y ofrecerá todas las garantías de protección y secreto profesional señaladas en el artículo 24 de la Ley De Profesiones Del Estado De Nuevo León y sus demás correlativos en el resto de los Estados Unidos Mexicanos.

C. Cuentas de los Usuarios
8. Cuentas de los Usuarios. Actividades restringidas. Suspensión o interrupción del Servicio
Al registrarse como Usuario del Sitio, el Usuario estará obligado a proporcionar su nombre(s) y apellidos y una contraseña para tener acceso a su cuenta de Sitio. Usted es responsable de mantener la confidencialidad de su contraseña y los datos de su cuenta; además, por lo que se le previene de no compartir esta información, ni su cuenta con nadie y será el único responsable de todos los actos o las omisiones en relación con su cuenta. Notificará de inmediato a www.escritoriolegal.com.mx  cualquier uso no autorizado de su contraseña o su cuenta. Debe crear solamente una cuenta en el Sitio. Si una cuenta de www.escritoriolegal.com.mx  que le pertenezca se ha suspendido o cerrado, no deberá abrir otra cuenta en el Sitio, y en caso de hacerlo www.escritoriolegal.com.mx  se deslinda de toda responsabilidad relacionada con el Usuario y las actividades que realice.

Usted acepta mantener actualizada su información de contacto y en caso de solicitar factura sus datos de facturación (que incluye, entre otros datos, su dirección de correo electrónico), y cumplir con todos los procedimientos de facturación, que incluyen suministrar información de facturación legal de acuerdo a los ordenamientos locales vigentes y aplicables para los Estados Unidos Mexicanos, de manera precisa para las cuentas activas de www.escritoriolegal.com.mx  y actualizarla. En caso que usted no solicite factura los primeros 3 días hábiles posteriores al cobro www.escritoriolegal.com.mx  emitirá una factura de servicio al público en general.

Actividades que podrán restringirse. Usted acepta que cualquier contenido que proporcione dentro del Sitio y su uso interno: 
i.	No será fraudulento, inexacto o engañoso; 
ii.	No infringirá ningún derecho de publicidad o privacidad, o de propiedad exclusiva de terceros (www.escritoriolegal.com.mx  ha adoptado Procedimientos de Retirada para el uso no autorizado de material con derechos de autor); 
iii.	No será ilegal ni infringirá ninguna ley, estatuto, ordenanza, regla o código ético; 
iv.	No será competitivo con www.escritoriolegal.com.mx  o con el Sitio; 
v.	No será difamatorio, injuriante, ni representará una amenaza o acoso ilegal; 
vi.	No será obsceno o pornográfico de cualquier índole y podrá ser eliminado.
vii.	No contendrá virus, troyanos u otras rutinas de programación electrónica que puedan dañar, interferir perjudicialmente con, interceptar clandestinamente o expropiar cualquier información personal, dato o sistema; 
viii.	No nos responsabilizará ni nos hará perder (total o parcialmente) los servicios de nuestros proveedores de Internet o de otros proveedores; 
ix.	En general incumpla cualquier ley a juicio de www.escritoriolegal.com.mx  
x.	Presentará un vínculo directo o indirecto a bienes o servicios, o incluirá descripciones de bienes o servicios que 
a)	Estén prohibidos conforme a los Términos o 
b)	Usted no tenga derecho a vincular o incluir. No puede concretar ninguna transacción que se haya iniciado mediante el uso de nuestro Servicio y que, mediante el pago de una comisión, pudiera hacernos infringir cualquier ley, estatuto, ordenanza o regla vigente. Además, no puede revender ni hacer ningún uso comercial de nuestro sistema o del contenido del Sitio sin el consentimiento previo por escrito de www.escritoriolegal.com.mx .


Se prohíbe convocar a los Usuarios de este Sitio, incluidos los Profesionales, con cualquier fin (que incluye invitar a otros Usuarios a comunicarse con usted fuera del Sitio o invitarlos a participar en un sitio web que compita con www.escritoriolegal.com.mx  o con el Sitio, o que cobre dinero por recibir respuestas o comunicarse con supuestos Profesionales).

Suspensión o interrupción del Servicio.
Si desea interrumpir el servicio, puede hacerlo enviándonos un aviso por escrito con su decisión. Debe enviar su notificación por correo electrónico a cancela@escritoriolegal.com.mx Las cancelaciones se efectuarán a un lapso máximo de siete (7) días posteriores a la solicitud de terminación. 

En cualquier momento, sin aviso previo, con o sin motivo, www.escritoriolegal.com.mx  se reserva el derecho de negarle el servicio a cualquier persona, de modificar o descontinuar el Servicio en forma parcial o total y de restringir, suspender y cerrar las cuentas de los Usuarios.

9. Política de cobros y de reembolsos
La plataforma de www.escritoriolegal.com.mx  permite publicar preguntas para que las vean los Profesionales, facilita la comunicación con los Profesionales a través del chat, los correos electrónicos y chat permiten proporcionar respuestas a las preguntas, entre otros servicios. Los clientes del sitio serán acreedores a los servicios del sitio mediante el pago por activación de una cuenta a través de las plataformas Google Play y/o Apple Store.
Los clientes del sitio pueden optar por uno de los dos modelos de pago disponibles: (1) modelo de pago por asesoría y (2) modelo de suscripción. El usuario paga la suma que aparece en el sitio y no se aplican impuestos o tarifas adicionales, por el uso de la plataforma.
En el caso de requerir el usuario un servicio presencial, este se sujetará al contrato de prestación de servicios de www.escritoriolegal.com.mx, distinto al que actualmente se presenta.
Pago por asesoría. 
Con el modelo de pago por asesoría, el usuario está dispuesto a pagar por disfrutar de las ventajas de acceso al sitio en relación con un tema en específico. Una vez pagado el importe, su pregunta se podrá publicar en www.escritoriolegal.com.mx. Los Profesionales suelen responder con rapidez, o bien con una solicitud de información adicional o bien con una o varias preguntas. En el caso de las solicitudes de información adicional o preguntas, es importante que aproveche la oportunidad de comunicarse directamente con el Profesional a fin de que este pueda pedirle la información adicional que necesita para responder a la pregunta.
Una vez registrado su pago recibirá orientación por parte de un Profesional, quien brindará dicha información por escrito dándole la oportunidad de calificar el servicio recibido. Al solicitar la asesoría estará ordenando y autorizando el pago a www.escritoriolegal.com.mx  para disfrutar de las ventajas de acceso al sitio. 
Suscripción. 
Las suscripciones permiten a los clientes disfrutar de las ventajas de acceso al sitio para múltiples preguntas formuladas por una tarifa mensual, trimestral, semestral o anual periódica, formuladas responsablemente en cantidad y categoría (www.escritoriolegal.com.mx  sancionará el uso inapropiado dentro de sus criterios de uso, de esta modalidad de contrato). Cada periodo de suscripción, los clientes reciben un cargo automático de la tarifa, que se transfiere a cualquier cuenta bancaria que decida www.escritoriolegal.com.mx  Como cliente de suscripción, una vez que formule una pregunta se le pedirá que haga clic en el botón "Aceptar", lo que autorizará a cualquier cuenta bancaria que decida www.escritoriolegal.com.mx  . Si por cualquier motivo no cree que una respuesta sea útil, tiene la opción de desestimarla y solicitar una segunda opinión la cual será definitiva, y en caso de persistir la inconformidad, podrá el cliente de suscripción (por un costo adicional) sea asistido de manera personal por un abogado interno www.escritoriolegal.com.mx . Al final de cada periodo de suscripción, cualquier fracción de la tarifa de suscripción que siga vigente se pagará a www.escritoriolegal.com.mx  como compensación por las ventajas de acceso al sitio de las que el usuario ha disfrutado durante el periodo de suscripción.

La suscripción de cualquier modalidad se considerará un contrato a plazo forzoso a tiempo determinado, por lo que el cliente disfrutará de los servicios por el plazo contratado, aún si este decide no utilizar el servicio, se verá obligado al pago de las cuotas contratadas. Las políticas de reembolso aplicaran al criterio de www.escritoriolegal.com.mx.

Si acepta una suscripción y más tarde acepta incrementar su plazo de servicio, se aplicarán las condiciones de la última suscripción seleccionada y se cancelará la suscripción anterior amortizando un ejecutivo manualmente las cantidades antes liquidadas aplicándolas al costo total de la nueva suscripción. Los clientes de suscripción estarán vinculados a estos detalles de suscripción, por lo que es recomendable que los lea con detenimiento. Para cancelar una suscripción, deberá enviar un correo electrónico a la siguiente dirección cancela@escritoriolegal.com.mx  
Los Profesionales no pueden participar en el programa de suscripción de www.escritoriolegal.com.mx 
D. Declaraciones legales

10. Liberación
Los Usuarios son responsables de sus actos y omisiones y del contenido presentado en el Sitio. Debido a que el Sitio de www.escritoriolegal.com.mx  es un servicio, en el caso de que usted participe de una disputa con uno o más Profesionales, usted libera a www.escritoriolegal.com.mx  (y a sus ejecutivos, directivos, agentes, organizaciones matrices, subsidiarias, empresas conjuntas y empleados) de cualquiera y todas las reclamaciones, demandas y daños (reales y emergentes) de cualquier clase y naturaleza, conocidos y desconocidos, sospechados y no sospechados, divulgados y no divulgados, y en general cualquiera que sea y que surjan a causa de estas disputas o estén de alguna manera relacionados con ellas. 

11. Derechos de propiedad exclusiva del contenido
Usted reconoce que www.escritoriolegal.com.mx  y sus licenciadores y proveedores son propietarios de los derechos de www.escritoriolegal.com.mx  y del contenido exhibido en el Sitio. Usted no modificará, aplicará ingeniería inversa, descompilará, desensamblará ni intentará derivar el código fuente del sitio web www.escritoriolegal.com.mx , ni ayudará a ninguna otra persona o entidad para que lo haga. Usted reconoce que todo el contenido, que incluye, entre otros, texto, software, música, sonido, fotografías, videos, gráficos u cualquier otro material incluido en listados, anuncios publicitarios de patrocinadores o información comercial distribuida en cualquier forma incluido sin limitar el servicio del sistema  es propiedad de www.escritoriolegal.com.mx

Los usuarios de www.escritoriolegal.com.mx  o los publicistas u otros proveedores de contenido de www.escritoriolegal.com.mx , están protegidos por derechos de autor, marcas registradas, marcas de servicio, patentes u otros derechos y leyes de propiedad exclusiva en caso que aplique. Usted no puede modificar, copiar, reproducir, republicar, cargar, publicar, transmitir ni distribuir de ninguna manera contenido que esté disponible a través del Servicio, que incluye código y software con ningún fin. 

A fin de obtener permiso para utilizar materiales de terceros que aparezcan en el Sitio, comuníquese con el propietario de los derechos de autor. Usted no adquiere los derechos de propiedad de ningún contenido, documento u otros materiales que se visualizan a través del Sitio. La publicación de información o materiales en el Sitio no constituye una renuncia a ningún derecho en dicha información y materiales.

www.escritoriolegal.com.mx  se compromete a proteger y conservar la información proporcionada por sus usuarios dentro de estándares y reglamentos internos equiparables a lo estipulado en el artículo 24, fracción IV. De la Ley De Profesiones Del Estado De Nuevo León y sus demás relativos en el resto de los Estados Unidos Mexicanos. 

Usted le otorga a www.escritoriolegal.com.mx  todos los derechos relacionados con su caso legal,  irrevocable, perpetuo, de validez mundial, exento del pago de regalías, transferible únicamente a cualquier parte del grupo de www.escritoriolegal.com.mx  (a través de cualquier nivel) otorgando así mismo los derechos sobre la base de datos, incluido el derecho a usar, reproducir, editar, copiar, modificar, extraer o crear trabajos derivados de éstos, que tenga en sus Publicaciones y Contenido de Usuario, en cualquier medio conocido actualmente o no conocido en este momento, con respecto a cualquiera de las Publicaciones mencionadas y otro Contenido de Usuario. www.escritoriolegal.com.mx   podrá utilizar en público cualquier caso o asesoría legal como ejemplo del servicio, guardando siempre la confidencialidad sobre los nombres y personas involucrados en cada caso legal o asesoría.

12. No se avalan las entidades ajenas a www.escritoriolegal.com.mx . No se establece relación con los usuarios
www.escritoriolegal.com.mx  puede intentar ofrecer a sus Usuarios productos y servicios ofrecidos por entidades ajenas a www.escritoriolegal.com.mx. La colocación de información, logotipos, vínculos o nombres de estas entidades ajenas a www.escritoriolegal.com.mx  en el Sitio no constituye un aval, ni una garantía de estas entidades y/o sus productos o servicios. Usted asume toda la responsabilidad por la decisión de visitar o ser cliente de una entidad tal y no le causará perjuicios a www.escritoriolegal.com.mx  por cualquier responsabilidad que surja de estas acciones. Además, reconoce que la creación de este Acuerdo (o cualquiera de los Acuerdos Relacionados) o su participación en el Sitio no establece ninguna relación (por ejemplo, de sociedad, agente, empresa conjunta o empleado) entre cualquier Usuario (incluidos los Clientes y los Profesionales) y www.escritoriolegal.com.mx. ES RESPONSABILIDAD DEL USUARIO EVALUAR LA PRECISIÓN, LA INTEGRIDAD Y LA UTILIDAD DE CUALQUIER OPINIÓN, RESPUESTA U OTRO CONTENIDO DISPONIBLES A TRAVÉS DEL SITIO, POR PARTE DE TERCEROS U OBTENIDOS DE UN SITIO VINCULADO. SOLICITE EL ASESORAMIENTO DE PROFESIONALES, SEGÚN CORRESPONDA, RESPECTO DE LA EVALUACIÓN DE CUALQUIER OPINIÓN, RESPUESTA, PRODUCTO, SERVICIO U OTRO CONTENIDO ESPECÍFICOS.

13. Control y almacenamiento de la información
No controlamos la información suministrada por los Usuarios, la que puede resultarle ofensiva, perjudicial, imprecisa o engañosa. Utilice el Sitio con precaución y sentido común. También existen riesgos para el Profesional de relacionarse con personas menores de edad o que actúan de manera fraudulenta. Además, puede haber riesgos de relacionarse con comercio internacional y con extranjeros. Al utilizar este sitio, usted acepta estos riesgos y el hecho de que www.escritoriolegal.com.mx  no se hace responsable de las acciones o las omisiones de los Usuarios en el Sitio.

Actualmente, la cantidad de espacio de almacenamiento por Usuario es limitada. Usted acepta que www.escritoriolegal.com.mx  no es responsable en el caso de que se elimine o no pueda almacenar contenido y/u otra información.

14. Exclusión de garantías
LOS SERVICIOS DE WWW.ESCRITORIOLEGAL.COM.MX  Y LA DOCUMENTACIÓN RELACIONADA SE PROPORCIONAN TAL COMO SON Y SIN NINGUNA GARANTÍA DE CUALQUIER CLASE, EXPRESA O IMPLÍCITA, INCLUIDAS, ENTRE OTRAS, LAS GARANTÍAS IMPLÍCITAS DE COMERCIABILIDAD Y ADECUACIÓN PARA UN FIN ESPECÍFICO. NINGUNA INFORMACIÓN, SEA ESCRITA O VERBAL, QUE USTED RECIBA DE NOSOTROS A TRAVÉS DE ESTE SITIO CREARÁ NINGUNA GARANTÍA O DECLARACIÓN NO MENCIONADAS EXPRESAMENTE EN ESTOS TÉRMINOS. WWW.ESCRITORIOLEGAL.COM.MX  NO DECLARA NI GARANTIZA QUE EL SERVICIO ESTARÁ EXENTO DE INTERRUPCIONES Y ERRORES, QUE LOS DEFECTOS SE CORREGIRÁN O QUE ESTE SITIO O EL SERVIDOR QUE LO HABILITA ESTÁN LIBRES DE VIRUS U OTROS COMPONENTES PERJUDICIALES. WWW.ESCRITORIOLEGAL.COM.MX  NO DECLARA NI GARANTIZA QUE EL USO O LOS RESULTADOS DEL USO DE LOS MATERIALES DISPONIBLES A TRAVÉS DEL SERVICIO, DE TERCEROS O DE UN SITIO VINCULADO SERÁN CORRECTOS, PRECISOS, PUNTUALES, CONFIABLES U OTROS. ALGUNOS ESTADOS U OTRAS JURISDICCIONES NO PERMITEN LA EXCLUSIÓN DE GARANTÍAS IMPLÍCITAS, POR LO QUE LAS EXCLUSIONES ANTERIORES QUIZÁ NO SEAN VÁLIDAS PARA USTED. TAMBIÉN ES POSIBLE QUE USTED TENGA OTROS DERECHOS QUE VARÍAN ENTRE LOS ESTADOS Y ENTRE LAS JURISDICCIONES.

WWW.ESCRITORIOLEGAL.COM.MX  NO SERÁ RESPONSABLE, EN NINGUNA CIRCUNSTANCIA, DE NINGUNA PÉRDIDA O DAÑO CAUSADOS POR LA CONFIANZA DEL USUARIO EN INFORMACIÓN OBTENIDA A TRAVÉS DEL SITIO, DE TERCEROS (COMO PROFESIONALES U OTROS) O DE UN SITIO VINCULADO, O POR LA CONFIANZA DEL USUARIO EN CUALQUIER PRODUCTO O SERVICIO OBTENIDO DE UN TERCERO O UN SITIO VINCULADO. EL USO DE ESTE SITIO ES RESPONSABILIDAD EXCLUSIVA DEL USUARIO.

NINGUNA INFORMACIÓN O ASESORAMIENTO, SEAN ESCRITOS O VERBALES, QUE USTED OBTENGA DE WWW.ESCRITORIOLEGAL.COM.MX  O A TRAVÉS DE LOS SERVICIOS DE WWW.ESCRITORIOLEGAL.COM.MX  O POR PARTE DE ÉSTOS SE CREARÁ NINGUNA GARANTÍA.

15. Limitación de responsabilidades
WWW.ESCRITORIOLEGAL.COM.MX , SUS ORGANIZACIONES MATRICES, SUBSIDIARIAS, AFILIADAS, EJECUTIVOS, DIRECTIVOS, ACCIONISTAS, EMPLEADOS O PROVEEDORES NO SERÁN RESPONSABLES, EN NINGÚN CASO, DE NINGÚN DAÑO DIRECTO O INDIRECTO, ESPECIAL, INCIDENTAL, EMERGENTE, PUNITIVO O EJEMPLAR (INCLUIDOS, ENTRE OTROS, PÉRDIDA DE ACTIVIDAD MERCANTIL, LUCRO CESANTE, PÉRDIDA DE DATOS, USO, INGRESOS U OTRA VENTAJA ECONÓMICA) QUE SURJA DE O EN RELACIÓN CON NUESTRO SITIO, DE NUESTROS SERVICIOS O DE CUALQUIER TÉRMINO, AUNQUE SE NOS HAYA ADVERTIDO DE LA POSIBILIDAD DE TALES DAÑOS. LA LIMITACIÓN DE DAÑOS ESTABLECIDA ANTERIORMENTE ES UN ELEMENTO FUNDAMENTAL DE LA BASE DEL CONVENIO ENTRE EL USUARIO Y NOSOTROS. ESTE SITIO Y LA INFORMACIÓN NO SE OFRECERÍAN SIN TALES LIMITACIONES. EN NINGÚN CASO, NUESTRA RESPONSABILIDAD, Y LA RESPONSABILIDAD DE NUESTRAS ORGANIZACIONES MATRICES, SUBSIDIARIAS, EJECUTIVOS, DIRECTIVOS, EMPLEADOS, PROFESIONALES Y PROVEEDORES, CON RESPECTO AL USUARIO O A CUALQUIER TERCERO, SUPERARÁ, EN NINGUNA CIRCUNSTANCIA, (A) EL MONTO DE LA ADQUISICIÓN DE LOS SERVICIOS QUE USTED PAGÓ A WWW.ESCRITORIOLEGAL.COM.MX 

Las partes renuncian expresamente a los tribunales que les correspondan de conformidad con su domicilio o cualquier otro, sometiéndose expresamente en este acto a los tribunales competentes de la ciudad de Monterrey, Estado de Nuevo León, México.

16. Indemnización
Usted acepta indemnizar a www.escritoriolegal.com.mx , a toda y cualquier organización matriz, subsidiaria o afiliada, a todo y cualquier ejecutivo, directivo, agente, accionista, asesor, empleado, sucesor y cesionario, y acepta que no nos causará perjuicios con respecto a todo costo, pérdida, obligación y gasto, incluidos los honorarios razonables de abogados, que reclame www.escritoriolegal.com.mx  o cualquier tercero y que de algún modo se deba al uso o surja del uso que usted haya hecho del Sitio o del comportamiento que usted haya tenido en el Sitio.

17. Notas de prensa y prensa de terceros acerca de www.escritoriolegal.com.mx 
El Sitio puede incluir notas de prensa y otra información sobre www.escritoriolegal.com.mx . Si bien esta información se consideró precisa en el momento de su preparación, negamos todo deber u obligación de actualizar esta información o las notas de prensa. No se debe interpretar que www.escritoriolegal.com.mx  proporciona o avala la información incluida en las notas de prensa u otros medios sobre empresas que no sean nuestras. Del mismo modo, no se debe interpretar que www.escritoriolegal.com.mx  proporciona o avala la prensa de terceros sobre www.escritoriolegal.com.mx  o el Sitio.

18. Elección de derecho y foro
ELECCIÓN DE DERECHO. Los Términos se regirán e interpretarán conforme a las leyes del estado de Nuevo León, independientemente de sus disposiciones sobre discrepancias legales.

DISPUTAS. RESOLUCIÓN DE DISPUTAS.
Todas las disputas, reclamaciones y controversias entre las Partes, de cualquier clase y naturaleza, que surjan del uso del Sitio (“Disputa”) se resolverán solamente en conformidad con el siguiente procedimiento: 
1.	Notificación a la otra parte de los hechos de la Disputa, la base legal de la Disputa y todos los daños declarados, por escrito, que se debe enviar 
a)	A la dirección de correo electrónico que tenga registrada www.escritoriolegal.com.mx  o
b)	En forma escrita en  calle Río Amacuzac número 1109-A, colonia Valle Oriente, San Pedro Garza García, Nuevo León, México 
c)	Correo electrónico a cancela@escritoriolegal.com.mx, con el nombre del asunto “Notificación de la Disputa”;
2.	Autorización de treinta (30) días desde la recepción de la Notificación de la Disputa para recibir una respuesta y/u oferta para solucionar la Disputa;
3.	Si la Disputa continúa sin resolverse en el lapso de esos treinta (30) días, la presentación de una Solicitud de Mediación por el Centro Estatal de Métodos Alternos para la Solución de Conflictos para lo que las Partes deben obrar de buena fe para resolver la disputa durante la mediación y deben dividirse por igual el costo de la mediación; 

RECLAMACIÓN PRESENTADA DE FORMA INAPROPIADA. 
Todas las Disputas deben resolverse conforme a lo establecido anteriormente. Si se efectúa de otra manera, se considerará que las Disputas se presentan en forma inapropiada, lo que el Usuario deberá pagar a www.escritoriolegal.com.mx  los costos y honorarios de abogados.

NO SE PERMITEN LAS RECLAMACIONES COLECTIVAS. RENUNCIA. 
Las partes aceptan expresamente que no se permitirán las asociaciones, fusiones o reclamaciones colectivas en ninguna disputa entre las partes, y que no se puede realizar ninguna reclamación a través de una acción que pretenda representar a una clase de Usuarios del Sitio. Por lo tanto al momento de aceptar este contrato los Usuarios renuncian expresamente a cualquier tipo de reclamación o demanda colectiva. 

19. Acuerdo, cesión y disposiciones varias
Los Términos constituyen la declaración completa y exclusiva del Acuerdo entre el Usuario y nosotros. Estos reemplazan todo y cualquier acuerdo anterior o actual, verbal o escrito, y toda otra comunicación, declaración, garantía y convenio que tenga relación con el contenido de los Términos. En caso de haber algún tipo de discrepancia entre una declaración verbal o escrita de cualquier empleado o agente de www.escritoriolegal.com.mx  y los Términos (excepto las modificaciones a los Términos realizadas por escrito por el director ejecutivo o un representante autorizado de www.escritoriolegal.com.mx ), prevalecerán los presentes Términos. 

En la medida en que los Términos presenten algún tipo de discrepancia o no concuerden entre sí, los Términos del Servicio prevalecerán para los Clientes, y el acuerdo de Profesionales prevalecerá para los Profesionales, sobre otros Términos del Sitio. Si un tribunal competente determina que alguna de las disposiciones de los Términos es contraria a la ley, se interpretará que tal disposición, en la medida de lo posible, refleja las intenciones de las partes y las demás disposiciones continuarán en plena vigencia. El hecho de que www.escritoriolegal.com.mx  no ejerza o no haga cumplir alguno de los Términos no constituirá una renuncia de www.escritoriolegal.com.mx  al derecho de ejercer o hacer cumplir los Términos en cuanto a lo mismo u otra instancia. Los encabezados de este Acuerdo y de los Acuerdos Relacionados sólo tienen fines de referencia y no limitarán ni afectarán de otra manera el significado de los Términos.

Usted acepta que www.escritoriolegal.com.mx  puede ceder los Términos y/o derechos a cualquier otra entidad que escoja, independientemente de si le envía o no un aviso a Usted. Usted no puede ceder los Términos y/o derechos a ninguna otra parte por ningún motivo, que incluyen, entre otros, su interacción con otros Usuarios del Sitio, el precio ofrecido, o cualquier información presentada por el Usuario en el Sitio. 


No se considerará que www.escritoriolegal.com.mx  haya renunciado a ninguno de sus derechos o recursos a menos que tal renuncia se realice por escrito y esté firmada por un representante legal de www.escritoriolegal.com.mx. Ninguna demora u omisión por parte de www.escritoriolegal.com.mx  para ejercer cualquier derecho o hacer uso de cualquier recurso actuará a modo de renuncia a tales derechos o recursos. Los títulos de las secciones de los Términos se usan únicamente como referencia.


'''),
              ),
            ],
          ),
        )
    );
  }
}


